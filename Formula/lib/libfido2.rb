class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/refs/tags/1.17.0.tar.gz"
  sha256 "ace062d14a482ff9325410ff63d06c8b5fe87e79ebc18dda07add2bc0188c77f"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e0df39436ee2a482eca7566c22e04ad96a076af7e4ba3bf94e7f600d7da0203"
    sha256 cellar: :any,                 arm64_sequoia: "1ae5fb9238e2e24b5c980f5ee80a7e6360695ed9bfb634a9650a76ba1de78d06"
    sha256 cellar: :any,                 arm64_sonoma:  "c401ede66a7b0accb44e6fa381bf137188c810fc6124b791cc6534dd24790cc7"
    sha256 cellar: :any,                 sonoma:        "5a6ffc55ffc19bd62ebf9e4182e0b39376d290ed71ccfa20f2bea4ce58cce2c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31bf79664d64bfefdf1bbf7ca09172ea48711eb6417857fffbdec3b13397be90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdad5bf5869d7ce4151ca98c45e4f84ea55f555c1bf2e03dd5eb73210d49f6e9"
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libcbor"
  depends_on "openssl@3"

  on_linux do
    depends_on "systemd" # for libudev
    depends_on "zlib-ng-compat"
  end

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

    flags = shell_output("pkgconf --cflags --libs libfido2").chomp.split
    system ENV.cc, "test.c", "-I#{include}", "-o", "test", *flags
    system "./test"
  end
end
