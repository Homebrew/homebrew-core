class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/libkrun/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.19.8.tar.gz"
  sha256 "8896c71117462f868f41d26efd157c3270091814eaab3af27ca70c6857a85eb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "040790c401d18b584957ead5aa2af24545c373ad6154148ce5b39521af1d2ec3"
    sha256 cellar: :any, arm64_tahoe:       "a6f13778fcdaa8ea106ebccabf7a4c9fe1ab4a08e2c9e4025f0c27e69c2f0ee1"
    sha256 cellar: :any, arm64_sequoia:     "516700738faaf5a152e8dde1d877d824ce4a74881f39bc425692769b61afe02f"
    sha256 cellar: :any, arm64_linux:       "81bc8b0fe6383cd50a9c58227f09ef949fed848d0a8edd3cedcb53a55143df70"
    sha256 cellar: :any, x86_64_linux:      "30f2d5170550a705d0a83fffa88287a6756dfffb8a60883087bbe64e1bdb8ef4"
  end

  depends_on "rust" => :build
  depends_on "zig" => :build
  depends_on "libkrunfw" => :no_linkage # via dlopen

  on_macos do
    depends_on "meson" => :build
    depends_on "ninja" => :build
    depends_on "pkgconf" => :build
    depends_on arch: :arm64
    depends_on "libepoxy"
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "pkgconf" => :build
    on_intel do
      depends_on "bzip2"
    end
    depends_on "virglrenderer"
  end

  # Some changes for macOS-specific support are still in the process
  # of being integrated into upstream virglrenderer
  resource "virglrenderer-krun" do
    url "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/0.10.4e-krunkit/virglrenderer-0.10.4e-krunkit.tar.gz"
    sha256 "09d000623fbdb966cb604eb48c962a0815e8142383e6066d6494809335b76dbb"
  end

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  deny_network_access!

  def install
    if OS.mac?
      resource("virglrenderer-krun").stage do
        # Build a static library to avoid having to install it into libexec
        system "meson", "setup", "build", "-Dvenus=true", "-Drender-server=false", "-Ddefault_library=static",
               *std_meson_args(prefix: buildpath/"virglrenderer-krun")
        system "meson", "compile", "-C", "build"
        system "meson", "install", "-C", "build"

        # As a shared library, the dependency on molten-vk would be recorded
        # in the dylib, but this won't work with a static library. Explicitly
        # add it as a dependency in the pkg-config file instead.
        inreplace buildpath/"virglrenderer-krun/lib/pkgconfig/virglrenderer.pc",
                  "Libs: -L${libdir} -lvirglrenderer -lm",
                  "Libs: -L${libdir} -lvirglrenderer -lm " \
                  "-L#{formula_opt_lib("molten-vk")} -lMoltenVK"
      end
      ENV.prepend_path "PKG_CONFIG_PATH", buildpath/"virglrenderer-krun/lib/pkgconfig"
    end

    # Zig provides static musl for the embedded guest init on both platforms.
    # On macOS, a non-empty SYSROOT_LINUX disables the Makefile's Debian sysroot.
    make_args = %w[BLK=1 NET=1 GPU=1 TIMESYNC=1]
    target = Hardware::CPU.arm? ? "aarch64-linux-musl" : "x86_64-linux-musl"
    make_args << "CC_LINUX=#{formula_opt_bin("zig")}/zig cc -target #{target}"
    make_args << "SYSROOT_LINUX=#{buildpath}/.empty" if OS.mac?
    system "make", *make_args
    install_args = ["PREFIX=#{prefix}"]
    install_args << "LIBDIR_Linux=lib" if OS.linux?
    system "make", *install_args, "install"
  end

  test do
    krunfw_name = (formula_opt_lib("libkrunfw")/shared_library("libkrunfw")).realpath.basename
    (testpath/"test.c").write <<~C
      #include <libkrun.h>
      #include <stdint.h>
      #include <stdio.h>
      #include <string.h>

      #ifdef __APPLE__
      #include <mach-o/dyld.h>
      #endif
      #define KRUNFW_NAME "#{krunfw_name}"

      static int krunfw_loaded(void)
      {
      #ifdef __APPLE__
          uint32_t count = _dyld_image_count();
          for (uint32_t i = 0; i < count; i++) {
              const char *image = _dyld_get_image_name(i);
              if (image && strstr(image, KRUNFW_NAME))
                  return 1;
          }
      #else
          FILE *maps = fopen("/proc/self/maps", "r");
          if (!maps)
              return 0;
          char line[4096];
          int found = 0;
          while (fgets(line, sizeof(line), maps)) {
              if (strstr(line, KRUNFW_NAME)) {
                  found = 1;
                  break;
              }
          }
          fclose(maps);
          return found;
      #endif
          return 0;
      }

      int main()
      {
          int c = krun_create_ctx();
          if (c < 0) {
              fprintf(stderr, "krun_create_ctx failed: %d\\n", c);
              return 1;
          }

          // Confirm that krun_create_ctx successfully dlopened libkrunfw
          if (!krunfw_loaded()) {
              fprintf(stderr, "libkrun did not load %s\\n", KRUNFW_NAME);
              return 1;
          }
          return 0;
      }
    C

    rpaths = [lib, formula_opt_lib("libkrunfw")]
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrun",
          *rpaths.map { |rpath| "-Wl,-rpath,#{rpath}" }, "-o", "test"
    system "./test"
  end
end
