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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "06658d0d79459f49d320f9c5cd89c159d979a7ea43e0a49e97b2acdce21def28"
    sha256 cellar: :any,                 arm64_monterey: "729646bc7da324d0eb385e9451701b1e3e666bf41c11724d15477e0cd6126b8b"
    sha256 cellar: :any,                 arm64_big_sur:  "6cb7c26d22552777bad28ec383bf993c682854687c856a225e317dd5fece4414"
    sha256 cellar: :any,                 ventura:        "98971343311c1469b7ea36eaf3985ed53dc5357c046406e1687acf757ae3d0e1"
    sha256 cellar: :any,                 monterey:       "8dfb353b286cd249ae131079e85c86cffaed3cd50510c8041608c15e13ff6dae"
    sha256 cellar: :any,                 big_sur:        "73f277426ffdbe38dfacb5f6966ce3f06a1ec97079ba27b442658b9feefbb082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e980b52d7a54229cc06224f7b158ba867be367a105c0780cb8839adb974390ec"
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
