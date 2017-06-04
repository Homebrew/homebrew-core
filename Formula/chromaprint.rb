class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.2/chromaprint-1.4.2.tar.gz"
  sha256 "989609a7e841dd75b34ee793bd1d049ce99a8f0d444b3cea39d57c3e5d26b4d4"
  revision 1

  depends_on "cmake" => :build
  depends_on "fftw" => :optional

  def install
    args = std_cmake_args
    args << "-DFFT_LIB=fftw3" if build.with? "fftw"
    system "cmake", ".", *args
    system "make", "install"
  end
end
