class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.8.0.tar.gz"
  sha256 "554291188f24ab595cb947f9d2b6ec40ce5afe39d9257c1e2cd0bdef8bf7fd1d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "dc337533af36a3756e758f13590a09a62b9dbe92740f14129af70fc0f48f1f20"
    sha256 cellar: :any,                 big_sur:       "c128be0d0ff853f9db7c921c1b1272a11671525aa6b2d34b11a8d8ea26989d7d"
    sha256 cellar: :any,                 catalina:      "13c88e8935bae584abcc70e817328009689689e1e057b6f0e0df99f88481b702"
    sha256 cellar: :any,                 mojave:        "faa172bd93fb5976aa8044ec0a4b1ce07832d4681b70309529bdc5207e7b7392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4ee18fc6862c83e0662060a240acad3ae0b7a10c139df78da277d342280d4d5"
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
