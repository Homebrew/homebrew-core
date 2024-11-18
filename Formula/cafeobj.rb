class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://cafeobj.org/files/1.6.2/cafeobj-1.6.2.tar.gz"
  sha256 "a086c43f5f886175a580b6ddff9c430a535a1da8db202986f7555ba8d2ce50fe"
  revision 2

  bottle do
    sha256 arm64_big_sur: "1912508b031a0b0e098c3195a044d0a2f4988d8906bdc2c5cfae1c98e508f59a"
    sha256 big_sur:       "724109123713a037126847a07fe06e4fa134d3e28aff72ae72de7f8f4fa77576"
    sha256 catalina:      "7e5281633b3f18239282905a748c61b702b2d059daf559fd52187aa6d079e79c"
    sha256 mojave:        "1a875e6c86c2d15862f0b64ee9bb90077bff62748d3c2d91f201527ea78886ac"
  end

  depends_on "sbcl"

  def install
    system "./configure", "--with-lisp=sbcl", "--prefix=#{prefix}", "--with-lispdir=#{share}/emacs/site-lisp/cafeobj"
    system "make", "install"
  end

  test do
    system "#{bin}/cafeobj", "-batch"
  end
end
