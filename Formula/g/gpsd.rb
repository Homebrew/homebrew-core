class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.28.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.28.tar.xz"
  sha256 "a3e76caa74a10929f13addfc89ea3dcf0b6be38ec528817101a6e6bf8cdad06d"
  license "BSD-2-Clause"
  compatibility_version 2
  head "https://gitlab.com/gpsd/gpsd.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "e77459c3c7b18cb357fc203232faafef71332a9dc2580e1942ccd9ed78896a04"
    sha256 cellar: :any, arm64_golden_gate: "1d211c8e1cea8c3dd8394a609a411a920fa6b8629b913d7acbf2383f8fc02866"
    sha256 cellar: :any, arm64_tahoe:       "a05a5d2b8936a441803d373da198f9727771c04fd8bc8426f77e61bd342eb2bb"
    sha256 cellar: :any, arm64_sequoia:     "fa57210d49523f88ce3023d753c802ffc4bbc9119c22226e3a1cdecef08029f2"
    sha256 cellar: :any, arm64_linux:       "eca204c122dcc865f66faa10484d886d642be728c7c6505061baf861a93a54bf"
    sha256 cellar: :any, x86_64_linux:      "fe414ce89861bec7d15aa2aab173af43b9a980b68306f55f6d84969334edce63"
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
