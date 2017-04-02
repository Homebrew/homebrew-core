class Ppl < Formula
  desc "Parma Polyhedra Library: numerical abstractions for analysis, verification"
  homepage "http://bugseng.com/products/ppl"
  url "http://bugseng.com/products/ppl/download/ftp/releases/1.2/ppl-1.2.tar.xz"
  sha256 "691f0d5a4fb0e206f4e132fc9132c71d6e33cdda168470d40ac3cf62340e9a60"

  bottle do
    sha256 "925201fe3772b8dc994c8edc742fe6925426a534a62f8d706c94ba8a859eacf7" => :sierra
    sha256 "34a1396fefc946754958e92d7ecffde0175b33f16f4545f46a00d4f63408cfd8" => :el_capitan
    sha256 "83c3f03aa0766155e98e322409f6d4389bfee3ec510848c7eab1c91329d5fa82" => :yosemite
    sha256 "d174ac172a3c986dfa92fe650354ce6b614d080f5ab497c90fc9b6395faf5caf" => :mavericks
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
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
