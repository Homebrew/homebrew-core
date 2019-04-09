class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20181209-3.1.tar.gz"
  version "20181209-3.1"
  sha256 "2811d70c0b000f2ca91b7cb1a37203134441743c4fcc9c37b0b687f328611064"

  bottle do
    cellar :any
    sha256 "1b7e3f4cccfa06d5a3d8fe33c06e5869fab7bfee9eda1cd18e5d3119c7bc443f" => :mojave
    sha256 "34212b672fa3ef16078af0ad77285ad9f37efb6df0b5296ec3cdd0ffc608bf6c" => :high_sierra
    sha256 "4ea358a29078a8903c38616ad60160d2c330797a644256f8b877013d21842816" => :sierra
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
