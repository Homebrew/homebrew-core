class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.27.5.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.27.5.tar.xz"
  sha256 "dc4a62bad835282bae788772bc7cc8f8bec4c7a48e8dceeb37477a89091c4656"
  license "BSD-2-Clause"
  head "https://gitlab.com/gpsd/gpsd.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5cdc0a238acdc4be1f968169fd823ee8a138bacad9eff804f893be065dc7d82"
    sha256 cellar: :any,                 arm64_sequoia: "a0e7d0e6077b4987e4e7d6ba2e3c969fd3e7cf0c054bed1978df3968a569ee0b"
    sha256 cellar: :any,                 arm64_sonoma:  "d55005371ee46f49596bb42f99bb043a4150b201a877795d06c643b0b20e34ba"
    sha256 cellar: :any,                 sonoma:        "80c664a6bbd8649eb3e82e2b3c357f41552996310a7c6a6d84e6101561705692"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0e890be6d0dad6ef97fc14eb6cfd7cfafec60ce53c61d15def98640dfb50bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1966e876bbef9de7ddc508979cd0557c66f5d0cb321fa7d333b855e43a5b6e8"
  end

  depends_on "asciidoctor" => :build
  depends_on "scons" => :build

  uses_from_macos "ncurses"

  def install
    if OS.linux?
      ncurses = Formula["ncurses"]

      ENV.append "CFLAGS", "-I#{ncurses.opt_include}"
      ENV.append "LDFLAGS", "-L#{ncurses.opt_lib} -Wl,-rpath,#{ncurses.opt_lib}"
    end

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
