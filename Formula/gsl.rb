class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftpmirror.gnu.org/gsl/gsl-2.2.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gsl/gsl-2.2.1.tar.gz"
  sha256 "13d23dc7b0824e1405f3f7e7d0776deee9b8f62c62860bf66e7852d402b8b024"

  bottle do
    cellar :any
    sha256 "3e762d44c1d72ae29e392b7215bdcd6a98c8e2ed17492d603dcdfa56e00edd94" => :sierra
    sha256 "89462bab1b0b7001ce6b71db851960f005c0436ffac840f3b9cc255ed7cb8d44" => :el_capitan
    sha256 "00e0d7aa1202bededfa2bdce311dd7ff08db0e412e45bd87b783eb29305ccde5" => :yosemite
    sha256 "00a05716a23a7bc333782dd77f547942563912650445d557aa5c8c941ac22c7e" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
