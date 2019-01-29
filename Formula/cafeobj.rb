class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://cafeobj.org/files/1.5.9/cafeobj-1.5.9.tar.gz"
  sha256 "a4085e9ee060a8a0a22cb7c522c17aa1ccadb5bdce8f90085e08ded3794498d4"

  depends_on "sbcl"

  def install
    system "./configure", "--with-lisp=sbcl", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cafeobj", "-batch"
  end
end
