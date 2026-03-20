class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/refs/tags/1.16.0.tar.gz"
  sha256 "7d86088ef4a48f9faad4ff6f41343328157849153a8dc94d88f4b5461cb29474"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "432fd520ac9a846d45b344c4ce888fd6ffb898c78e289710de6aac0add686fb6"
    sha256 cellar: :any,                 arm64_sequoia: "979c5922c7fc50b44cd52b56cc5864c5d084cdc5b7f37e0ef69f611cd02bbf2d"
    sha256 cellar: :any,                 arm64_sonoma:  "a6446fead07bb8d304ae5d6580dca5f4860a9acbfa01fc45bef79df7cd95eb62"
    sha256 cellar: :any,                 sonoma:        "c218ca912276907a8b7690f03649becd474c64bb0b12749b6136f3ffc7703126"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e95b21e17cf4fe231733612ebb7b524e5cacd27b20fb4828e0b3818b45ed00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd9420fb40c7b95ab6011f9d8149a9406a32083d2044ca9dc0a1a4885f9b352"
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
