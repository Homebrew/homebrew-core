class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.25.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.25.tar.xz"
  sha256 "7e5e53e5ab157dce560a2f22e20322ef1136d3ebde99162def833a3306de01e5"
  license "BSD-2-Clause"
  head "https://gitlab.com/gpsd/gpsd.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "9a3bb3d5594e1b63686b3d40b42f1d8dedf396b03c952a6a758d74d374c08452"
    sha256 cellar: :any,                 arm64_sonoma:   "938cf9f4d6bd4ad1ab1ef1f553921dbc6db46810fff2715f25ad8c0aae4a1258"
    sha256 cellar: :any,                 arm64_ventura:  "12a924778ab1fcc13aff5d84ac712db09bc964f85fc57b7677f1566c5e870008"
    sha256 cellar: :any,                 arm64_monterey: "7ce33dccf34d5beab1ebd4a98dfd1b3bb284be93a43e367e5bb446258da36144"
    sha256 cellar: :any,                 sonoma:         "db21b97f74091e71a97e6e0aa09352bc651c6dd95245d408b9ab11c1b4354a07"
    sha256 cellar: :any,                 ventura:        "2b7ae1f6de349089583d3a426f4240eca86cb98d478ed11a1156f8835664f4d1"
    sha256 cellar: :any,                 monterey:       "583ff8896e5f9f211c5487dc35cb54b1ccecb16b1b3d466c5ba8112ff90ea0fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fb850dbc722b6e0dbdd8340ec74918b905ae3122da9ff2037754e79f3970671d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06b4c52b968483ec4a90e103696af37e423555b2c3808ce726feb0a1855f87b8"
  end

  depends_on "asciidoctor" => :build
  depends_on "scons" => :build

  uses_from_macos "ncurses"

  # Replace setuptools in SConscript for python 3.12+
  patch do
    url "https://gitlab.com/gpsd/gpsd/-/commit/9157b1282d392b2cc220bafa44b656d6dac311df.diff"
    sha256 "b2961524c4cd59858eb204fb04a8119a8554560a693093f1a37662d6f15326f9"
  end

  def install
    system "scons", "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    system "scons", "install"
  end

  def caveats
    <<~EOS
      gpsd does not automatically detect GPS device addresses. Once started, you
      need to force it to connect to your GPS:

        GPSD_SOCKET="#{var}/gpsd.sock" #{sbin}/gpsdctl add /dev/tty.usbserial-XYZ
    EOS
  end

  service do
    run [opt_sbin/"gpsd", "-N", "-F", var/"gpsd.sock"]
    keep_alive true
    error_log_path var/"log/gpsd.log"
    log_path var/"log/gpsd.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/gpsd -V")
  end
end
