class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.14/cups-2.4.14-source.tar.gz"
  sha256 "660288020dd6f79caf799811c4c1a3207a48689899ac2093959d70a3bdcb7699"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "82a53180db14fe9e4d21d0a1786c75c5bb065dd60dc6393c7f69a64b024cddb7"
    sha256 arm64_sequoia: "70ee985cb5ece4650a0ae16a9d692317f169432bf1d69d2bc136d4cc9a5ce8b0"
    sha256 arm64_sonoma:  "911492a3ff757deb8a13cf83c58405407c814007d54e8d5713ff9332a7873dc7"
    sha256 arm64_ventura: "e44a25e754a0773c56fa56016b7bee4ae69e09f9d5c14888311aaa89947d8de2"
    sha256 sonoma:        "7ed7bab4ea5f5205214298ad2b2552b5b34ac633c319a08b6bb9a7a37bce066b"
    sha256 ventura:       "b73cb43b4abe94d517d0015151eae6a43b86be634b754cdbb81b4e8b617caa85"
    sha256 arm64_linux:   "42760db0b5250393a5e633f3c3056e30e5179b94217c656bcfe36cf1a1ea053a"
    sha256 x86_64_linux:  "a648e8c6b2a9b0637ebb075a772614a7f242b7a7ae1cf77e64315000030a1948"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    system "./configure", "--with-components=core",
                          "--with-tls=openssl",
                          "--without-bundledir",
                          *std_configure_args
    system "make", "install"
  end

  test do
    port = free_port.to_s
    pid = spawn "#{bin}/ippeveprinter", "-p", port, "Homebrew Test Printer"

    begin
      sleep 2
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      assert_match("Homebrew Test Printer", shell_output("curl localhost:#{port}"))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
