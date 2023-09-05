class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  url "https://github.com/miek/inspectrum/archive/v0.2.3.tar.gz"
  sha256 "7be5be96f50b0cea5b3dd647f06cc00adfa805a395484aa2ab84cf3e49b7227b"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/miek/inspectrum.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "8a34eeb6438451da34d80743d43610ffc0f36943e24c8d71038a94c0afea6843"
    sha256 cellar: :any,                 arm64_monterey: "987ec702b9c0a62d782d08827ceca63cf930e3b32fa65b3ac6d6c1a808fc4c80"
    sha256 cellar: :any,                 arm64_big_sur:  "c87caeeaecdf7dee81c4c8d557a5acb25a511a6a80418d829f0e87293970cd61"
    sha256 cellar: :any,                 ventura:        "802a9b0c1775c15610f8024542fbd4263df60370b8ebbd8dbf7ddaa98a1efa9e"
    sha256 cellar: :any,                 monterey:       "bf95d982178b20894aa627dc49c4af81601d78dbd7cca7ad17d75d73676f3a9e"
    sha256 cellar: :any,                 big_sur:        "a3b1a2e902c182dbe8821025facb01cfe6b35945cc88302e7e1a14904ef98778"
    sha256 cellar: :any,                 catalina:       "17c0d00e0191db31868a384d773ee1ac74da82fd01ceee06b425e99b15809670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7b5c146e089b5eceb3ccf9456ba2c15b2535c9eafdbe4e37ed92512ea79cdd5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "-r, --rate <Hz>     Set sample rate.", shell_output("#{bin}/inspectrum -h").strip
  end
end
