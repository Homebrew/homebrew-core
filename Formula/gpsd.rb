class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.23.1.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.23.1.tar.xz"
  sha256 "ca2c466df783c57b8a07ad3f5c67943186d05befdc377de938ed111d1358a8c1"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ec8c94a333277ff13aba8916ab3d434dc19de4b55cbf110dc7747a6d62b16366"
    sha256 cellar: :any,                 arm64_big_sur:  "883c90ed12472d9116910ac3bed524ed400b2c1a7a702fd1e61c281a7689ddca"
    sha256 cellar: :any,                 monterey:       "cd3594200ba2689bee0aec4aa3dd54036128ea5fe87aed2138867cd6f2eb9471"
    sha256 cellar: :any,                 big_sur:        "9f7217ce185daeb8e0a596db9aca4fb501eb053c37d043d36ebc7cae51edc806"
    sha256 cellar: :any,                 catalina:       "7abff1947d861eb50d2f631c5d5ef6930d968d882ac64604111ba0495a86c9d5"
    sha256 cellar: :any,                 mojave:         "39246316c1b4cefa12a9835f2da96b924a71f48ffadd0a7518c3b6df9f6fbd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68b07cf9cfaf44ccdafbb7096a207f7b57b4ce4d9ba95867c128658f1b45c5a9"
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
