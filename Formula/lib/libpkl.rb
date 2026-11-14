class Libpkl < Formula
  desc "C library calling into Pkl's message passing API"
  homepage "https://pkl-lang.org/main/current/libpkl/index.html"
  url "https://github.com/apple/pkl/archive/refs/tags/0.33.0.tar.gz"
  sha256 "b232e7149705f4f4922dd27d4693c9ea97fa32b3fec9d45ef6f3297dccf2858c"
  license "Apache-2.0"

  depends_on "gradle" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :test

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    args = %W[
      --no-daemon
      -DreleaseBuild=true
      -Dpkl.native-Dpolyglot.engine.userResourceCache=#{HOMEBREW_CACHE}/polyglot-cache
    ]

    system "gradle", *args, "libpkl:buildNative"

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    os_name = OS.mac? ? "macos" : "linux"
    native_libs = "libpkl/build/native-libs/#{os_name}-#{arch}"

    include.install "#{native_libs}/include/pkl.h"
    lib.install Dir["#{native_libs}/lib/libpkl.*"]
    (lib/"pkgconfig").install Dir["#{native_libs}/lib/pkgconfig/*.pc"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <string.h>
      #include "pkl.h"

      int main(void) {
        const char *ver = pkl_version();
        assert(ver != NULL);
        assert(strcmp(ver, "#{version}") == 0);
        return 0;
      }
    C

    ENV["PKG_CONFIG_PATH"] = lib/"pkgconfig"
    flags = shell_output("pkg-config --cflags --libs libpkl").chomp.split
    system ENV.cc, "test.c", *flags, "-Wl,-rpath,#{lib}", "-o", "test"
    system "./test"
  end
end
