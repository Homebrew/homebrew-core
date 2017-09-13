class GslAT1 < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz"
  sha256 "73bc2f51b90d2a780e6d266d43e487b3dbd78945dd0b04b14ca5980fe28d2f53"

  bottle do
    cellar :any
    sha256 "e637950a3f49a8fa79627a26fd3f12a97e2652dc64fd3ec0a83b8fcb08ae405f" => :sierra
    sha256 "5e342feaaadaabca0b79312a69d8a3ce9686c60d1840b40affecaa011e4b634c" => :el_capitan
    sha256 "642a923d212bc967a8d235eb37177f1b21a6d165b6adf14041ae5e42d37c25c2" => :yosemite
  end

  keg_only :versioned_formula

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
