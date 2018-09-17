class Lastfmfpclient < Formula
  desc "Last.fm fingerprint library"
  homepage "https://github.com/lastfm/Fingerprinter"
  url "https://github.com/lastfm/Fingerprinter/archive/9ee83a51ac9058ff53c9.tar.gz"
  version "1.6"
  sha256 "c72c61bf5b60f7924f55c0a8809d2762768716db8bce9a346334c2aaefb9ce85"

  bottle do
    cellar :any
    sha256 "0b13f5df198a0118fc7d53df0d9155e4504598b8153fed1e1ab3617621b8fbab" => :mojave
    sha256 "65b9b1840dd935c6320b45eeffbba1251ee4a414ecd103c9bbe185416a9d36cd" => :high_sierra
    sha256 "f7bcdf3d68d7e4e5fcf1797a879755e97ea218c157ffb027d21d9d1f452ae6d7" => :sierra
    sha256 "f54f327160766c2b10f3f74fcdf698556200cec2e632370065675618470e02e1" => :el_capitan
    sha256 "560736062bc0ce9e64d5845de635ac47c0feac645b95848433129fea4abc7763" => :yosemite
    sha256 "31832999bcbce4e8e8ce1fc67908b126bc3ab050a10e7d68ced2ec5bfc75a48e" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "libsamplerate"
  depends_on "mad"
  depends_on "taglib"

  def inreplace_fix
    # This project was made on Windows (LOL), patches against Windows
    # line-endings fail for some reason, so we will inreplace instead.
    # Fixes compile with clang failure due to entirely missing variable, how
    # on earth did GCC ever compile this?!
    inreplace "fplib/src/FloatingAverage.h",
      "for ( int i = 0; i < size; ++i )",
      "for ( int i = 0; i < m_values.size(); ++i )"
  end

  def install
    inreplace_fix
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
