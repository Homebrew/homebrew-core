class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://cafeobj.org/files/1.6.0/cafeobj-1.6.0.tar.gz"
  sha256 "ab97d3cf22d8556524c86540cbb11d4e2eb1ba38cb0198eb068a4493b745d560"
  revision 2

  bottle do
    sha256 "724109123713a037126847a07fe06e4fa134d3e28aff72ae72de7f8f4fa77576" => :big_sur
    sha256 "7e5281633b3f18239282905a748c61b702b2d059daf559fd52187aa6d079e79c" => :catalina
    sha256 "1a875e6c86c2d15862f0b64ee9bb90077bff62748d3c2d91f201527ea78886ac" => :mojave
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
