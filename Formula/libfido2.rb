class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.6.0.tar.gz"
  sha256 "6aed47aafd22be49c38f9281fb88ccd08c98678d9b8c39cdc87d1bb3ea2c63e4"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "3194f38a17f35276bb4e8863048d640a4115e5c059be92b10641f3bfe7c8e0c3" => :big_sur
    sha256 "491588603fb5af1e9f0cedd7506a2b005d85e2ee8ddde9e8150149c8bd0462fb" => :arm64_big_sur
    sha256 "7325754f60c62f8015cdbdd2d8c301f3b3caec734f01f23f6f62a4d4347b6fe1" => :catalina
    sha256 "4349516e03fb119f1acf3e06604501e2906c4eb030e8260fdaa786f651ddb05e" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libcbor"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
    system ENV.cc, "-std=c99", "test.c", "-I#{include}", "-I#{Formula["openssl@1.1"].include}", "-o", "test",
                   "-L#{lib}", "-lfido2"
    system "./test"
  end
end
