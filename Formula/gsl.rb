class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.7.tar.gz"
  sha256 "efbbf3785da0e53038be7907500628b466152dbc3c173a87de1b5eba2e23602b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b4d8687427eb3a7f951c211f5a0b8051ca0bbaf174e68265fb6619d43b282aeb"
    sha256 cellar: :any, big_sur:       "49b52d742f10f6a62de28658419c33ab11027eef3427e81b771921bf8d068637"
    sha256 cellar: :any, catalina:      "5972e8669b2560124278b43788a002e3ff22f024c761750a1a33b41d2002f292"
    sha256 cellar: :any, mojave:        "6c88a066c85f76c93a20f6e3256fb9022d6e7db828d184be5b42fd0b322ca7b8"
    sha256 cellar: :any, high_sierra:   "8213b1a73d038e499223ccae6d04afe6eb2d9455e327d9558351cf47a0431b84"
    sha256 cellar: :any, sierra:        "8515f26e5a06a99097e87dc9b88ee79787b95448ab67f09b449aee4b0d67bdba"
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
