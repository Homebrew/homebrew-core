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
    sha256 "8eed2907ba0d36d073a53a2556693826113b2aad09256c1451f3c9defd275c75" => :big_sur
    sha256 "d874c7af4aea94eb15304c13bc1b5c10c63db79f3d4e78ae6f41a73ecc78d4fd" => :arm64_big_sur
    sha256 "8f00138524b80aa2b4df62a75ddee6e2ebbd89670335b733f58fc529b2e2872d" => :catalina
    sha256 "e749bd85f784c552184fce875caa01d6095991362a95796e4ceeb68bf68f9bd3" => :mojave
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
