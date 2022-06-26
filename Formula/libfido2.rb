class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.11.0.tar.gz"
  sha256 "0830c5853e3b44099a97166e0cec54a65b54b7faaac07071872f77b8e4d7b302"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7efcbcc6ba548f2410d5fdf45788782de457a0dc6093220eacf89480fcd496db"
    sha256 cellar: :any,                 arm64_big_sur:  "6b3b260583c40834aec71d64de1a679e27ea3e7da1788a8d913bca38b7985f10"
    sha256 cellar: :any,                 monterey:       "aeb657a45d240d679bebf88fd5d8fe9253464fe7aa986a34e6531c1c531baf25"
    sha256 cellar: :any,                 big_sur:        "e4ffb026a067f1d1fb49eb0033bfac05f29a4a390790fd1b29aee00363ed62d2"
    sha256 cellar: :any,                 catalina:       "1029bd3cccdda9ba93a80ed44151ebb9153a6f79ece7110b2c4d1e014830b98f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd9ba79bc1fb55d32160414994b907ff66bcf7a4bbb11ac30518d763a912fa12"
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libcbor"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    args = std_cmake_args

    args << "-DUDEV_RULES_DIR=#{lib}/udev/rules.d" if OS.linux?

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "man_symlink_html"
      system "make", "man_symlink"
      system "make", "install"
    end
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
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["openssl@1.1"].include}", "-o", "test",
                   "-L#{lib}", "-lfido2"
    system "./test"
  end
end
