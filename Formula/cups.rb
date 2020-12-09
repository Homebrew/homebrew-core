class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  url "https://github.com/OpenPrinting/cups/releases/download/v2.3.3op1/cups-2.3.3op1-source.tar.gz"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  sha256 "5cf7988081d9003f589ba173b37bc2bbf81db43bb94e5e7d3e7d4c0afb0f9bc2"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git"

  bottle do
    sha256 "00bdcf0cb9e681d4e10bc7ec87eb57ccc9c63a5b76816a8545b77e454a8a0021" => :big_sur
    sha256 "1bed38f7aa9ee2c76fed5393e308cf7de5dd6d443debb0455ee7739e010b0e20" => :catalina
    sha256 "19ea09cef986e1c66f1736409f4e7917914100bb68525d8118e705500fbf28e0" => :mojave
    sha256 "0d3328bddece686cfa54e63b61f68c68fed1b1f8553cd45ed194d8a80e56f9c9" => :high_sierra
  end

  keg_only :provided_by_macos

  uses_from_macos "krb5"
  uses_from_macos "zlib"

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
