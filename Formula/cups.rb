class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.1/cups-2.4.1-source.tar.gz"
  sha256 "c7339f75f8d4f2dec50c673341a45fc06b6885bb6d4366d6bf59a4e6c10ae178"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_monterey: "15df1bb307a32d191cbad890de956c51653fee0693610225ead4c1ef6945bdb0"
    sha256 arm64_big_sur:  "419d584a24ba77babac25b785e5afa8e55e5aa00a20d63e46cbb093394218515"
    sha256 monterey:       "b877dfaa756f124d916fe4496009a1445444b179c20fe28ea2ba27bfe3e7ed35"
    sha256 big_sur:        "513b2ebce4382380ccbcb886c52d6fe1e21a85e143bf52c62ae37ef825923cc6"
    sha256 catalina:       "45b78b4621314f8645ff87d693031dceb27d795c88558be6372878c385190d9b"
    sha256 x86_64_linux:   "d3fc052a8a913bafc9481780ebc7b3bf4d9ce685a9bb5c62ec07ece33709f057"
  end

  keg_only :provided_by_macos

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnutls"
  end

  def install
    system "./configure", "--disable-debug",
                          "--with-components=core",
                          "--without-bundledir",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}"
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
