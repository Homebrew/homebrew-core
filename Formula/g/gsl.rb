class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.7.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.7.1.tar.gz"
  sha256 "dcb0fbd43048832b757ff9942691a8dd70026d5da0ff85601e52687f6deeb34b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2430e5586457f35f98014639a19d40c4d8d4b821949bb0cc7e091ac2aa9987bb"
    sha256 cellar: :any,                 arm64_monterey: "207ba177628696ce2179fe94125ecd637794396a442a7550c92f9a8a202c03bf"
    sha256 cellar: :any,                 arm64_big_sur:  "1184a75460c96dc80a9fa5299f3f0931bbff729b556607e2b7492608dd7e44d7"
    sha256 cellar: :any,                 ventura:        "9e28ec4b8e62b94c208312780b63f417b08c3ca80dcb7e7f7223e06675e2807c"
    sha256 cellar: :any,                 monterey:       "3125ff756739ec6eea0ddac3c3b01e879f525eb3b7de88586d6438cd954e28a8"
    sha256 cellar: :any,                 big_sur:        "3cfd6c05d383ad930471e6d92942de62982d5e4149d5508bbbf5ed513561c288"
    sha256 cellar: :any,                 catalina:       "03a4c21c0384602ec0d5c802f61fdc0737730a703396b3fe37274c884019a6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf456a559c5f031b5584db251ffe07aa02fbb04c3d7dc06e1202cfd9109a0c7"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
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
