class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.24.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.24.tar.xz"
  sha256 "dab45874c6da0ac604e3553b79fc228c25d6e71a32310a3467fb3bd9974e3755"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ee32da6d1a4cebc72344070d1f446a95e62446253453426a227a784a9986a2a"
    sha256 cellar: :any,                 arm64_big_sur:  "538fd1fc7101ca412dea133b318cabe4111708bb8b64d6fc14e74e92ec334d79"
    sha256 cellar: :any,                 monterey:       "fb3def1aeef8ecbc9e771bdcce032a808bcdaeaa72f48511c3a3d61baa6b5a72"
    sha256 cellar: :any,                 big_sur:        "771bb0164955c209ec3bfd4cc1801da5a4ca44feffdc493192906b39d245e833"
    sha256 cellar: :any,                 catalina:       "dfeda18cdf0234e2d2b3d8cc4146f3a1ba5f923b26cfdd8f4e97f6a1d72e3492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b8f2870eb113ea890064d3011f1508869211a0dc2679cf41c02aff5fe7e9022"
  end

  depends_on "asciidoctor" => :build
  depends_on "python@3.10" => :build
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
