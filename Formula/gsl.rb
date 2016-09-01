class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftpmirror.gnu.org/gsl/gsl-2.2.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gsl/gsl-2.2.1.tar.gz"
  sha256 "13d23dc7b0824e1405f3f7e7d0776deee9b8f62c62860bf66e7852d402b8b024"

  bottle do
    cellar :any
    sha256 "1c780a8c10c6779ec35f970cc28f0e4d5ddd4028554c2ba9fdc9f70da6b60d45" => :el_capitan
    sha256 "18542eac40fb739f39e6ad193a937ca6fa35bf9d484ded17e043c933795c85c6" => :yosemite
    sha256 "ebaf52f0f212ea4b9dcbf37d32d1ae4bd1b881d4a9aaf14a4a95e659c7bc28c4" => :mavericks
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
