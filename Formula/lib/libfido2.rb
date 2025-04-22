class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/refs/tags/1.15.0.tar.gz"
  sha256 "32e3e431cfe29b45f497300fdb7076971cb77fc584fcfa80084d823a6ed94fbb"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77a7f87267cbe477df703af3d80958c0de22f3a8466c1fa56c6f0dfbbdf790b8"
    sha256 cellar: :any,                 arm64_sonoma:  "71e2af315c37d9f530adaaaafb3f0507ee0dffd4006aa242df8ca5553270ea97"
    sha256 cellar: :any,                 arm64_ventura: "275606b563b5b5da93406363be140811b4b935e8a9de78757a73667d96d78011"
    sha256 cellar: :any,                 sonoma:        "722486b1889bcbd088be7e361ebc8f770a902f770b181fce53a19e851dcb2b69"
    sha256 cellar: :any,                 ventura:       "73955c899e3ef7463e3033045adcfa5a18731f58aa5dbc53f108fd96dabdd0f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c87591439f22000414d33cc9a182b0efb1e48e4096ba6b2b398b07f54675ac24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d8cbd9a644cc9317ee7742693b6a1066a8afeba5adb45e0c5b29d8bae0bb706"
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
