class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://cafeobj.org/files/1.6.0/cafeobj-1.6.0.tar.gz"
  sha256 "ab97d3cf22d8556524c86540cbb11d4e2eb1ba38cb0198eb068a4493b745d560"
  revision 2

  bottle do
    sha256 "98abc7f03647ba1f78d55c7f6b293d03b7abbf43f62f35512ecc40365051c11f" => :big_sur
    sha256 "759c36caf712b7dc37b078e8c544b87748f9fcf4d1979f8b6cd879b339b75602" => :catalina
    sha256 "7bebd25dbac82c676ef1901b2edbf3e543fc866d289376bb0faf6b603aa27d28" => :mojave
    sha256 "33f8dd427702d6271ec88656838212b7f5ca77ca72e44db4e5eaae08433abca8" => :high_sierra
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
