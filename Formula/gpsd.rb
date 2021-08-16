class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.23.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.23.tar.xz"
  sha256 "e36429b9f6fc42004894dff3dc4453f5b43f95af8533b96d3d135987418da9df"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "51fae36422568cde2845dfbd6e9f48ec38ac6d84ed0c3412581bee1612331340"
    sha256 cellar: :any,                 big_sur:       "b8d992eb67763ca693525720a70f546b2944b913ec93aee936a7c084995f5ceb"
    sha256 cellar: :any,                 catalina:      "7e347f09e9780efed87f483d2d1663655405539f32ef3741d5377909857b481f"
    sha256 cellar: :any,                 mojave:        "619c8ba68ab43aae14deb1ba148ed91e4d50e2eae5971893ed1f3a60165c39c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fb25eed89a7918bc5c84cc061f1308c24b43a6877be98da240a15d8bc7184dc"
  end

  depends_on "asciidoctor" => :build
  depends_on "python@3.9" => :build
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
