class Ppl < Formula
  desc "Parma Polyhedra Library: numerical abstractions for analysis, verification"
  homepage "http://bugseng.com/products/ppl"
  url "http://bugseng.com/products/ppl/download/ftp/releases/1.2/ppl-1.2.tar.xz"
  sha256 "691f0d5a4fb0e206f4e132fc9132c71d6e33cdda168470d40ac3cf62340e9a60"

  bottle do
    sha256 "54f3824838393715cebf5d8cc7a99e1578b7bbcbf1e3104505221f9dfdddac12" => :el_capitan
    sha256 "227619b5fff1b893d8ba6fde9d7026107e077ff70c7ef4f7c51f1599b45774f1" => :yosemite
    sha256 "1f8cdd6f99a760ec80cdc8277ea1627ee7a170c29980369e9daacdc986b2d852" => :mavericks
    sha256 "ed01b3815b6fc79b003b366604564e74599875c7bf295bb182cfc72359389caa" => :mountain_lion
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ppl_c.h>
      #ifndef PPL_VERSION_MAJOR
      #error "No PPL header"
      #endif
      int main() {
        ppl_initialize();
        return ppl_finalize();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lppl_c", "-lppl", "-o", "test"
    system "./test"
  end
end
