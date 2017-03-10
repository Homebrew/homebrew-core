class GslAT1 < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz"
  sha256 "73bc2f51b90d2a780e6d266d43e487b3dbd78945dd0b04b14ca5980fe28d2f53"

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
