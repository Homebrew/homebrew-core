class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  url "https://github.com/miek/inspectrum/archive/v0.2.2.tar.gz"
  sha256 "9e513101a59822c86b84cb7717f395c59bb27a6c192fe021cf4ffb7cf1d09c78"
  head "https://github.com/miek/inspectrum.git"

  bottle do
    cellar :any
    sha256 "54282d4f9ec25f3573d93b497197c5b240561321525fea3617a28efe02e3c16a" => :mojave
    sha256 "e54bcce14f93b2c84b738ca978b4b931df3b59d8c444288c5619a759b378a04c" => :high_sierra
    sha256 "0877551fa20ea67f1aab886ccd90577760ad7ab295787dd37e509283cb2129d2" => :sierra
    sha256 "ae97d37f999dab31422a9a9dac70756e8f5b97a0f6520cb59ae94bee5a992755" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "-r, --rate <Hz>  Set sample rate.", shell_output("#{bin}/inspectrum -h").strip
  end
end
