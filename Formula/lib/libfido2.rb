class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/refs/tags/1.15.0.tar.gz"
  sha256 "32e3e431cfe29b45f497300fdb7076971cb77fc584fcfa80084d823a6ed94fbb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b07f0c07f5b2bc30b51b11ab15bb6424bc6f12c2d777af1c88f5fc51eabd0456"
    sha256 cellar: :any,                 arm64_sonoma:   "af63db962f5466784b450d1052475668fdb7fd8588f6f0f52c952e4445739fda"
    sha256 cellar: :any,                 arm64_ventura:  "33c05cce853e59f211ae4dd2bac144b57d27a94537a79ffbee97c5efa34cbd4a"
    sha256 cellar: :any,                 arm64_monterey: "451806f5a0f08d301a6789d705614f2cf1c7dceeaa88005c584280f907924447"
    sha256 cellar: :any,                 sonoma:         "c25ffe40fef70db5d37372fcbe4d3e34eb50ba9c5c0e3714d3cbb09d07c9a73d"
    sha256 cellar: :any,                 ventura:        "2592f9c608fddf4d40e6dc9eb0d64e56fe3e960dbd51ef8abfe928c40ac1e27c"
    sha256 cellar: :any,                 monterey:       "139818589401f84797b5e581312b3a0208d0ce308eb0b7ae55e9546cd5bf674a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ebead53de6c6dd99885d4b3fb94cf0c753995a280824cb06b63b26e0bd1d40"
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "libcbor"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    args = std_cmake_args

    args << "-DUDEV_RULES_DIR=#{lib}/udev/rules.d" if OS.linux?

    system "cmake", "-S", ".", "-B", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--build", ".", "--target", "man_symlink_html"
    system "cmake", "--build", ".", "--target", "man_symlink"
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<-EOF
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
    EOF

    pkg_config_flags = shell_output("pkg-config --cflags --libs libfido2").chomp.split
    system ENV.cc, "test.c", "-I#{include}", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
