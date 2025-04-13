class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.12/cups-2.4.12-source.tar.gz"
  sha256 "b1dde191a4ae2760c47220c82ca6155a28c382701e6c1a0159d1054990231d59"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "705e803a739ead8c04537615685fedf880afc88a536315d939571a98911f7936"
    sha256 arm64_sonoma:  "dc4da71981a402f2cdf66008cec93ab1480826254633a815e835d442b32c8536"
    sha256 arm64_ventura: "1cfe5a32e6973737ae86e1f16b8cc104b5b5ac57243b8b787356adf687785c35"
    sha256 sonoma:        "38bf81dc15a0dca73492c12fc6912926bac447bd71fe4b3d0e7c5b6245dbd985"
    sha256 ventura:       "fd22e936b6d275b404c3a0b094624950b9dc27eb9924be1592792eec4e955c50"
    sha256 arm64_linux:   "ac4a05c8d6c069d1e486948aceee4edd97d8ff765b3282e077c69ca2d122580c"
    sha256 x86_64_linux:  "bf9ed3c684e203a1809506737ca7d167dbc4911019344298663f02792fb4fcaa"
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
