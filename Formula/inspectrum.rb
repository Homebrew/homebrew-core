class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  url "https://github.com/miek/inspectrum/archive/v0.2.3.tar.gz"
  sha256 "7be5be96f50b0cea5b3dd647f06cc00adfa805a395484aa2ab84cf3e49b7227b"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/miek/inspectrum.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a0fb5fe1d6d28598185e4b550c3eb023edd06caa538965143ad9368fb12fde29"
    sha256 cellar: :any, big_sur:       "50970461c14baf9ad20ddaf10ce822fab5d1a3d3c50119864ec18ada903c4bc4"
    sha256 cellar: :any, catalina:      "d1fab945b3121deb6e5e9fbfe761bbb550c2478f1c169266cc467fcf143c1ce1"
    sha256 cellar: :any, mojave:        "1bb0c291cfea17440808f50296634ff87ef9c6b1ddd28e3f1ea816eb4018597d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "qt@5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    on_linux do
      # This test requires X11.
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "-r, --rate <Hz>     Set sample rate.", shell_output("#{bin}/inspectrum -h").strip
  end
end
