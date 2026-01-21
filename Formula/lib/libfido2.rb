class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/refs/tags/1.16.0.tar.gz"
  sha256 "7d86088ef4a48f9faad4ff6f41343328157849153a8dc94d88f4b5461cb29474"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "338e0b3e52dd0096e00fc9fdad75248b943b6ba8746542050f2a70533e7e1f5b"
    sha256 cellar: :any,                 arm64_sequoia: "70ab4f30999b5a903cdf5d12d86ce198d68b9c2c6d663750136d559c34414fdb"
    sha256 cellar: :any,                 arm64_sonoma:  "74bea8577d47d68c8e14624cec351af4f20df35e5f609f7ecbc6874e6ba3d514"
    sha256 cellar: :any,                 arm64_ventura: "536aedd6c35b1222529bce53a343118892964a240016858c63406950a93825b2"
    sha256 cellar: :any,                 sonoma:        "6fee97e4c3918f85f16e1a250149a7854b67adea48f9fe1d63a0b3cf48770d87"
    sha256 cellar: :any,                 ventura:       "583f92599513718c97c33608a8bd170c024fa86db95635a1b9f9589b90beed94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6efd180717461d2385957a1a1611cf4dde0d0a1909c97785b85c2bf9f4ca2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a1f8eafd6fede2bc1a1cab400f7d55f3fb807af1d261edee7de9ea60c40304"
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libcbor"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "systemd" # for libudev
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
