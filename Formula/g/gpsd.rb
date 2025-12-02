class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.27.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.27.tar.xz"
  sha256 "aaddd19f7b67fb410178f3f8e27a8b40d434d5921d1c50272ddb3d6b9ca65ea9"
  license "BSD-2-Clause"
  head "https://gitlab.com/gpsd/gpsd.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b5b6db760ddc9191af1d378eeb6466dafc604d843c7342d625f8f2986321c22"
    sha256 cellar: :any,                 arm64_sequoia: "44d5958806ff6d80b80b6b35d20b1fef907eb7b5ff679a68fc5d4b1482dd2e24"
    sha256 cellar: :any,                 arm64_sonoma:  "1205b1bec25c84be7b3d4dddfdcfbef4f90d41e966656d192e2950beaafce3aa"
    sha256 cellar: :any,                 sonoma:        "1b00bbd1704cbbd821b7fd7a44340651ca86232bddc86aaa88c0954c39e56e47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb24e1b8c0ca2f32c84ceed37a7407a3f1bc9a1809e93959ed67536c5d6a517e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a92b817aff6b98dc7858341b87b546779af992b2aad4d48037564144ee9225e"
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
