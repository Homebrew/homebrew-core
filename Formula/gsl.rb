class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.6.tar.gz"
  sha256 "b782339fc7a38fe17689cb39966c4d821236c28018b6593ddb6fd59ee40786a8"

  bottle do
    cellar :any
    sha256 "2b76f0bb640a36340efb3bc44a9df6e8b1694cc251637f95eca02c541add53ff" => :mojave
    sha256 "a11e16ee61294794105faf42908ae1547617c822b19edca88a627917feb87f28" => :high_sierra
    sha256 "79ad420d6c495d16a7a3ed57c5a5000dcd4f77cb98af27b3eb6c21e1a748a451" => :sierra
    sha256 "af4c116bf27bc4880d85d1a50c62ba435e2a9bfae0b6a7f2a09f974791a91408" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
