class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.3.0.tar.gz"
  sha256 "27def29cc408d5c74926e8d0ef3a77fd76fee1e4f2797f840e999e6376a5be03"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2b54209f3658ad50d80da175d8058d8e00451032898d62dfba73b7ecb9c1422a"
    sha256 cellar: :any, big_sur:       "b643eb96e7161a4c3a3275f56dc3ac0e8705979a4f2a86efef5cdbe8353e78a1"
    sha256 cellar: :any, catalina:      "372245304f50bd572ff92c77d0fa0e97f58538075df07890bb1a3c35992e72ee"
    sha256 cellar: :any, mojave:        "602abd2b87dd217f5cd8ff178baa6c29be51578f05b7a942133cd240a6856beb"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.9"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.9"].opt_bin}/python3"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
