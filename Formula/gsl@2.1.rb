class GslAT21 < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.1.tar.gz"
  sha256 "59ad06837397617f698975c494fe7b2b698739a59e2fcf830b776428938a0c66"

  bottle do
    cellar :any
    sha256 "3e762d44c1d72ae29e392b7215bdcd6a98c8e2ed17492d603dcdfa56e00edd94" => :sierra
    sha256 "89462bab1b0b7001ce6b71db851960f005c0436ffac840f3b9cc255ed7cb8d44" => :el_capitan
    sha256 "00e0d7aa1202bededfa2bdce311dd7ff08db0e412e45bd87b783eb29305ccde5" => :yosemite
    sha256 "00a05716a23a7bc333782dd77f547942563912650445d557aa5c8c941ac22c7e" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
