class Liblastfm < Formula
  desc "Libraries for Last.fm site services"
  homepage "https://github.com/lastfm/liblastfm/"
  url "https://github.com/lastfm/liblastfm/archive/1.0.9.tar.gz"
  sha256 "5276b5fe00932479ce6fe370ba3213f3ab842d70a7d55e4bead6e26738425f7b"
  revision 2

  bottle do
    cellar :any
    sha256 "666b4220844dbab8143a3b04fafc086f08d2246d41eaa7fd6fac9b9cfb60db6a" => :mojave
    sha256 "b064d2c0725d5500cb5c9b3dff12e3e01fc10c0855b1763885dd489ab9c3c034" => :high_sierra
    sha256 "ed421bdd81c4643de07048e5d73575bb4a6909fce584c5e5b6760a5103cd0617" => :sierra
    sha256 "40e10cadb1dc55904ae6114a13597e7209596e1d274b94db8ac96f1ebf7da979" => :el_capitan
    sha256 "0d5342788a8f4eb95ea970d2247e829d7dac17db2d43713aacbf4617e742bbba" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "libsamplerate"
  depends_on "qt"

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
