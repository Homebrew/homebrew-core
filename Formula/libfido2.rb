class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.4.0.tar.gz"
  sha256 "ad921fbe7d4bb70e4a971e564cd01f341daf9b5ed5d69b3cbab94a8a811d2a6c"
  revision 1

  bottle do
    cellar :any
    sha256 "05a2921d34a126b66182c395b4ef8b27dbcfedebdeb0071dda16afac1020545f" => :catalina
    sha256 "d2a8202b550a1d2f66d6c166d6cbc74ec0d922c1c03a8b7e74841a01d314af3f" => :mojave
    sha256 "fe0c917aa89e682627dc649e3bad9f615174adcdbd4e43922b22c9767a7be2db" => :high_sierra
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
      if ((error = fido_dev_info_manifest(devlist, max_devices, &found_devices)) != FIDO_OK)
        return 1;
      printf("FIDO/U2F devices found: %s\\n", found_devices ? "Some" : "None");
      fido_dev_info_free(&devlist, max_devices);
    }
    EOF
    system ENV.cc, "-std=c99", "test.c", "-I#{include}", "-I#{Formula["openssl@1.1"].include}", "-o", "test",
                   "-L#{lib}", "-lfido2"
    system "./test"
  end
end
