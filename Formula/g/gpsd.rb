class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.25.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.25.tar.xz"
  sha256 "7e5e53e5ab157dce560a2f22e20322ef1136d3ebde99162def833a3306de01e5"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b66ca13a735d2dbf166b572f035f2bb56c551939cf0dd14e66ec427c45167fbc"
    sha256 cellar: :any,                 arm64_ventura:  "e9acbc066222d5eeeef6cd072b65d7c394d8b54943d80f40426f69c2cd6e8c7f"
    sha256 cellar: :any,                 arm64_monterey: "7d8b72dd69fee140654975b7f932ebd4bf527356e9256f76a39c958cccaf8cd1"
    sha256 cellar: :any,                 arm64_big_sur:  "5e563d468cecd7415ed0c064187a3083b4df611c502b24dff8b3314767c41adb"
    sha256 cellar: :any,                 sonoma:         "ec712553fec47bf5d396e73757d53f27d7ee234a99072254f7b65dc5e7f2a8d5"
    sha256 cellar: :any,                 ventura:        "6ddffba6867de189fc5b54a92c4a256ee5aa4e71a5690c30169d18efcbc3d63b"
    sha256 cellar: :any,                 monterey:       "d88a2ce7d9438b7c3402d7a55d8e7c09dac34609db903f47a0601be6cb093ab7"
    sha256 cellar: :any,                 big_sur:        "bb51fd5c72e41d1e35bc8338df4de04584bcdb095ab890f0d28ce7ed5867dace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbd26352543b06b8e06d964348137643dc43c51219f0bf56cbeac38f58e4c6b8"
  end

  depends_on "asciidoctor" => :build
  depends_on "python@3.11" => :build
  depends_on "scons" => :build

  uses_from_macos "ncurses"

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
