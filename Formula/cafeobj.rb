class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://cafeobj.org/files/1.6.0/cafeobj-1.6.0.tar.gz"
  sha256 "ab97d3cf22d8556524c86540cbb11d4e2eb1ba38cb0198eb068a4493b745d560"
  revision 2

  bottle do
    sha256 arm64_monterey: "d338e4868d48d4f244ff91c745de7d0fa6adf41825eb9bde53e371e01960381c"
    sha256 arm64_big_sur:  "1912508b031a0b0e098c3195a044d0a2f4988d8906bdc2c5cfae1c98e508f59a"
    sha256 big_sur:        "724109123713a037126847a07fe06e4fa134d3e28aff72ae72de7f8f4fa77576"
    sha256 catalina:       "7e5281633b3f18239282905a748c61b702b2d059daf559fd52187aa6d079e79c"
    sha256 mojave:         "1a875e6c86c2d15862f0b64ee9bb90077bff62748d3c2d91f201527ea78886ac"
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
