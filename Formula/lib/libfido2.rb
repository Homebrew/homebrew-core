class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/refs/tags/1.16.0.tar.gz"
  sha256 "7d86088ef4a48f9faad4ff6f41343328157849153a8dc94d88f4b5461cb29474"
  license "BSD-2-Clause"
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de7760db5c26f7f27d1e63c18160253e2be10b9c91420fa898b36c4f6c3f92c5"
    sha256 cellar: :any,                 arm64_sequoia: "8a0b4ea43277a6f1f10bb8eef33d7e781808813e31a5c9eb93fd3e5b0a0c370a"
    sha256 cellar: :any,                 arm64_sonoma:  "630853eec76c71352580531a7b2afff3db34ae94250e70575fb3bbcd41b6ac54"
    sha256 cellar: :any,                 sonoma:        "e6611f41c5e77ca4f0f813a37262c334d7a2b0087cbbb120ce1bb274eb6848aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3175cb4697597912eca08346a70ffbb6b4674dfb7a1ebd0059036c783edacca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c41af87d2533861806381d3ba6c36fd7fc713133f87422b45981597324a204f3"
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
