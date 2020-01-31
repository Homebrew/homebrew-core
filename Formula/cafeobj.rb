class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://cafeobj.org/files/1.6.0/cafeobj-1.6.0.tar.gz"
  sha256 "ab97d3cf22d8556524c86540cbb11d4e2eb1ba38cb0198eb068a4493b745d560"

  bottle do
    sha256 "94db8f954bca7bcea9d83bc36391ab7a5902c9a1b555a6c6aeac5ecdfa9edded" => :mojave
    sha256 "658c55bc4a10ca2b355bf37720bf28b2ae7757b7b259b80f7fef2aa87ab372af" => :high_sierra
    sha256 "a74c31e2e157724e11707f96cddfcf35ce56641f84c72f5ba854652afc5f6399" => :sierra
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
