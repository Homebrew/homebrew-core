class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.4.tar.gz"
  sha256 "4d46d07b946e7b31c19bbf33dda6204d7bedc2f5462a1bae1d4013426cd1ce9b"

  bottle do
    cellar :any
    sha256 "ea19659efea6c85dfda0b42468fd2d4bc980ec2689a07fa3506ea2a5fc9a9c89" => :sierra
    sha256 "0e58f3748624d439a7152557518e389827a8a38dfa7ea486625d38e86291f9b2" => :el_capitan
    sha256 "e8f5a126564d238ed734d3f069b183304ec1a707473cbce7fdde512122ccf3fb" => :yosemite
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
