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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "363e6a7e67b050a027ff46ae2c444c7f1125d39f515fe77e39cc9041656c7977"
    sha256 cellar: :any,                 arm64_big_sur:  "3b9099d2a71d641a8f1c935fa7a02b9535968fd2edef5584fc7143bc0f04d6b7"
    sha256 cellar: :any,                 monterey:       "df2284611cbdcd349ba5fdf8d7a0a21b710d41b7f8b770231fd70bdd76e3519f"
    sha256 cellar: :any,                 big_sur:        "328535be408821bb68bd55cf385c978b28043d4a561168a8f7dd3a200a41ae02"
    sha256 cellar: :any,                 catalina:       "f38c863774029e15c3a4a17213b470e82f1ca167cd1221d0d3b7efb2c953f92f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a8f97e40f3f2bf07d67731dcaee835fa0d9f211a05542a5420e363ef35d266"
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
