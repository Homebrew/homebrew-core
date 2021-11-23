class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-21.2.1.tgz"
  sha256 "b15a75dcf84b8f62e68720ccab1393f9611c078fcd3afdd639a1086cad010900"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.com/embeddable-common-lisp/ecl.git", branch: "develop"

  livecheck do
    url "https://common-lisp.net/project/ecl/static/files/release/"
    regex(/href=.*?ecl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "f22e7b333050fe84c8a5e277c87666c16f42655ebf3c1bf76815db67c9520e7f"
    sha256 big_sur:       "6881f61f6abc60969a668260a05ee06c2f7420b201b9ed4c2fb4b78b3ca4ae3c"
    sha256 catalina:      "81e01b8b899eaa0d835f6c303ad9346251c3f234c60ff34e2d70e59adefb21c6"
    sha256 mojave:        "fa6ce6c90d52cb11ec897693d18485fbcb7e2b066ea46fb3f588ff2cad3e1cc1"
    sha256 x86_64_linux:  "25bb43cb6297d30bbd4d8045ba179f8e17c431b723fb7d9d3768e77fe3d348b8"
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-libffi-prefix=#{Formula["libffi"].opt_prefix}",
                          "--with-libgc-prefix=#{Formula["bdw-gc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
