class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.26.1.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.26.1.tar.xz"
  sha256 "45c0d4779324bd59a47cfcb7ac57180d2dbdf418603d398a079392dabf1f740c"
  license "BSD-2-Clause"
  head "https://gitlab.com/gpsd/gpsd.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "54e49549e87a088ae8fded07a143dbf8cdd016d9b0b7adbba6ac2b56b8bd9827"
    sha256 cellar: :any,                 arm64_sonoma:  "b167722509389681bbbc08adda95eeddfaa7ea6be024ab60fc2d719212a01c88"
    sha256 cellar: :any,                 arm64_ventura: "5fd0ddadcb70eecd5489f8edc43cffeb22bf7c66d8fe1427d86fbec7e3e61bb9"
    sha256 cellar: :any,                 sonoma:        "6b28340a45b296b6d53262302f16f049c1e89d05d63a27c73c7f7f57800fbd86"
    sha256 cellar: :any,                 ventura:       "579f7f0ede210c94a98e5f3c2316ed24ef39b03eb990606dab320e0fc453852e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f1e1dc7c86b2b007721d43fff1861914f20532f7f1731c1388655128504fc4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bae4fededf6c737937b9fd73e7ecde613a6c7ffcdafaa36b879eab89397ce64c"
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
