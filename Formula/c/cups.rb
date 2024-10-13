class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.11/cups-2.4.11-source.tar.gz"
  sha256 "9a88fe1da3a29a917c3fc67ce6eb3178399d68e1a548c6d86c70d9b13651fd71"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "9ce97cb2305aa0b8fb73d5f104b47a5d0e22ea9583d1b15b8e9091962fbcd48c"
    sha256 arm64_sonoma:  "da9bb8ae69dc9c9b741d06cc4c3143961d2c084367ec60e50360e67a0c89be43"
    sha256 arm64_ventura: "e8b56d92ae803cbce09b2390b90705c520a3475607fb9c61ec6d2b9095000f3e"
    sha256 sonoma:        "bfdb13e6164cc005e1387d8d53df0e3aa5fb21c85546ff36e2838bf22a2a4102"
    sha256 ventura:       "0d1726c5edfcdba47a6ab127d39e8cbfa72c000746692db8f3fdc0213dbbfaf2"
    sha256 x86_64_linux:  "450c1b750daf7df268f6107c5bd585c9a1d20fe20914ff9f038e9f5bbf028380"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--with-components=core",
                          "--with-tls=openssl",
                          "--without-bundledir"
    system "make", "install"
  end

  test do
    port = free_port.to_s
    pid = fork do
      exec "#{bin}/ippeveprinter", "-p", port, "Homebrew Test Printer"
    end

    begin
      sleep 2
      assert_match("Homebrew Test Printer", shell_output("curl localhost:#{port}"))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
