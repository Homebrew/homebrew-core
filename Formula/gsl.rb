class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.7.tar.gz"
  sha256 "efbbf3785da0e53038be7907500628b466152dbc3c173a87de1b5eba2e23602b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "440a395f89375c90f383f84681dd5472463bee84319996c58fe58af0d75f5909"
    sha256 cellar: :any,                 big_sur:       "ea2a8b743f1a4825c5f8991a0f7bc16e805b846c0c5c8f35995ca3a730d7ad3a"
    sha256 cellar: :any,                 catalina:      "ed733561136f1dd07e3ce164a3c0e0d7857c98158349ca6481bee4bd71f422b7"
    sha256 cellar: :any,                 mojave:        "6bc76e54e0a4db8d8993605bf7662f1076e46ade1ee6c59424a44248b0c72a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b83d664557598a1bbf7bfdde1fd93ea17a5d199af45fef4a1cfeb0e3102a594"
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
