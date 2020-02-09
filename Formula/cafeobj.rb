class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://cafeobj.org/files/1.6.0/cafeobj-1.6.0.tar.gz"
  sha256 "ab97d3cf22d8556524c86540cbb11d4e2eb1ba38cb0198eb068a4493b745d560"

  bottle do
    sha256 "d04302998bd8b6885ceafd9506b55cae54d34d2c76ea8da7fc4ba808ecdd51dd" => :catalina
    sha256 "712981dcaf889bf309cf4395ebd6745f16189b8c85f2f6f6a99fc2dcc0964256" => :mojave
    sha256 "df6fa5ce81c5c6440ee7dab7beddd79559e90749f6e49c6826caeb883b41888c" => :high_sierra
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
