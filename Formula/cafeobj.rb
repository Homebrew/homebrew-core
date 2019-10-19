class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://cafeobj.org/files/1.5.9/cafeobj-1.5.9.tar.gz"
  sha256 "a4085e9ee060a8a0a22cb7c522c17aa1ccadb5bdce8f90085e08ded3794498d4"

  bottle do
    sha256 "d70c24f9be1cc6818b31442a8356cff23198712e67357def96a628ff43efb40b" => :catalina
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
