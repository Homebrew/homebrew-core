class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  url "https://github.com/miek/inspectrum/archive/v0.2.3.tar.gz"
  sha256 "7be5be96f50b0cea5b3dd647f06cc00adfa805a395484aa2ab84cf3e49b7227b"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/miek/inspectrum.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cb49666fff4b01b95a058d0c4426c54fa7656fa9bf238bfaca5f6452a474523d"
    sha256 cellar: :any,                 arm64_big_sur:  "a0fb5fe1d6d28598185e4b550c3eb023edd06caa538965143ad9368fb12fde29"
    sha256 cellar: :any,                 monterey:       "8ea325ef7a0b15bf6dab7e9eb427cdcb0930864bb0a36158ca377a863baac981"
    sha256 cellar: :any,                 big_sur:        "50970461c14baf9ad20ddaf10ce822fab5d1a3d3c50119864ec18ada903c4bc4"
    sha256 cellar: :any,                 catalina:       "d1fab945b3121deb6e5e9fbfe761bbb550c2478f1c169266cc467fcf143c1ce1"
    sha256 cellar: :any,                 mojave:         "1bb0c291cfea17440808f50296634ff87ef9c6b1ddd28e3f1ea816eb4018597d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a48eec06539f246874c2a3320071bda2f2fb74e77e561ecc102a0881b1b67237"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

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
