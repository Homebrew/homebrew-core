class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/refs/tags/1.17.0.tar.gz"
  sha256 "ace062d14a482ff9325410ff63d06c8b5fe87e79ebc18dda07add2bc0188c77f"
  license "BSD-2-Clause"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b679492d42f008427e7646538e1b12744a0793a8532ac1d946088781a8981edd"
    sha256 cellar: :any, arm64_tahoe:       "e00d6b923b4c560c04b6bda73cecacfaada8f1c0597ad765e3535ab9e7d1fe94"
    sha256 cellar: :any, arm64_sequoia:     "b404a7b93781536080839a6c16c23b757f540e1a0895ea8344bc39c34cea5edb"
    sha256 cellar: :any, arm64_linux:       "a49777a64ffc7dfe1752ec844a474896b696faf9c7a3d5d81c95273144ecc321"
    sha256 cellar: :any, x86_64_linux:      "cf69e18e0fad21c5b5f8c1b2bb76eddcd6636268b860d90457f28e886d997ff0"
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libcbor"
  depends_on "openssl@4"

  on_linux do
    depends_on "systemd" # for libudev
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = OS.linux? ? ["-DUDEV_RULES_DIR=#{lib}/udev/rules.d"] : []

    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--build", ".", "--target", "man_symlink_html"
    system "cmake", "--build", ".", "--target", "man_symlink"
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stddef.h>
      #include <stdio.h>
      #include <fido.h>

      int main(void) {
        fido_init(FIDO_DEBUG);
        // Attempt to enumerate up to five FIDO/U2F devices. Five is an arbitrary number.
        size_t max_devices = 5;
        fido_dev_info_t *devlist;
        if ((devlist = fido_dev_info_new(max_devices)) == NULL)
          return 1;
        size_t found_devices = 0;
        int error;
        if ((error = fido_dev_info_manifest(devlist, max_devices, &found_devices)) == FIDO_OK)
          printf("FIDO/U2F devices found: %s\\n", found_devices ? "Some" : "None");
        fido_dev_info_free(&devlist, max_devices);
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("openssl@4")/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs libfido2").chomp.split
    system ENV.cc, "test.c", "-I#{include}", "-o", "test", *flags
    system "./test"
  end
end
