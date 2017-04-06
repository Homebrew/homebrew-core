class Liblastfm < Formula
  desc "Libraries for Last.fm site services"
  homepage "https://github.com/lastfm/liblastfm/"
  url "https://github.com/lastfm/liblastfm/archive/1.0.9.tar.gz"
  sha256 "5276b5fe00932479ce6fe370ba3213f3ab842d70a7d55e4bead6e26738425f7b"
  revision 2

  bottle do
    cellar :any
    sha256 "b1093306f714a72838f9ede61c6dea5daf28953ff521d4270b27eedcfdded09a" => :sierra
    sha256 "77e844c5c3acf1a97f31316ca33cce8aed17d5f05b87096458b0674604c73ffc" => :el_capitan
    sha256 "d15b98bd3c926379927224e2f9771adb60acb74882db244007e7744cf8b8f83b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "fftw"
  depends_on "libsamplerate"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      cd "tests" do
        system "make"
      end
      share.install "tests"
    end
  end

  test do
    cp_r "#{share}/tests/.", testpath
    system "./TrackTest"
  end
end
