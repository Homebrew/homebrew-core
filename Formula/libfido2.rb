class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.3.1.tar.gz"
  sha256 "ba35e22016b60c1e4be66dff3cd6a60c1fe4bfa0d91ec0b89ca9da25ebeaaf41"

  bottle do
    cellar :any
    sha256 "b314bca188f5a034d0c6bb48aa941517321a2b4ead2a69e13a5651f2850fc92e" => :catalina
    sha256 "47faaf7e97b815f310ab62e42a317860f6ec521ebcf49c85fffe891672c6301a" => :mojave
    sha256 "97776fbb92f11ac8a27fd9a9011964d378099d11c4092bbe3c6dd1efd48d8a7e" => :high_sierra
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
    mv prefix/"man", share/"man"
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
      if ((error = fido_dev_info_manifest(devlist, max_devices, &found_devices)) != FIDO_OK)
        return 1;
      printf("FIDO/U2F devices found: %s\\n", found_devices ? "Some" : "None");
      fido_dev_info_free(&devlist, max_devices);
    }
    EOF
    system ENV.cc, "-std=c99", "test.c", "-I#{include}", "-I#{Formula["openssl@1.1"].include}", "-o", "test", "-L#{lib}", "-lfido2"
    system "./test"
  end
end
