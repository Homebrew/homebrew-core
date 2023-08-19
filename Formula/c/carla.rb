class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.5.6.tar.gz"
  sha256 "da8297f73edd1f5eb5f9760c390aba0ad5e8f82c7726df77730c3b964d2944db"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f40d26ba1898b9628003dc7da9cb9324f520e0a4d870fec013b1e450d4a9709"
    sha256 cellar: :any,                 arm64_monterey: "80cbd5a292cf69d9e94d30180991be0ac171ca44c07ef857e110a594985a24b5"
    sha256 cellar: :any,                 arm64_big_sur:  "6e1b63589a573636519dcee7a385c36139f1077f2913f50cd1cdd04341fa0bad"
    sha256 cellar: :any,                 ventura:        "48d1a43e33038469cb4db4d8421ed02040bad9ecd1d69e83f5169324dcd5de51"
    sha256 cellar: :any,                 monterey:       "1c9b10d24e45b71b05a29fc7f3fcd1c1af6746a5b885a2362b22a3715ba3f7fc"
    sha256 cellar: :any,                 big_sur:        "ee9450ef8a8b98b2c2d7588d109dae997e2729d0c1fc6856b3c20e09760a6a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba91983ada612da7e7b3a87b55db071d2dd32b58d21b39cf992d97f3710bf20a"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.11"].opt_bin}/python3.11"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
