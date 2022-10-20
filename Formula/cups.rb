class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.2/cups-2.4.2-source.tar.gz"
  sha256 "f03ccb40b087d1e30940a40e0141dcbba263f39974c20eb9f2521066c9c6c908"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_monterey: "187eac9ac47ede37e0026fdc7f709084babfe9f1910ba7acf90e433d369e4704"
    sha256 arm64_big_sur:  "225203fd3c07bfc63c8f62e1b96b0280f8c46ae2a89e5b71e6601f7ac52c0d23"
    sha256 monterey:       "b32ebe807e9c6dc266688580e9c45de1288e83d19cf7106f2d33d19ba11d4e1d"
    sha256 big_sur:        "11581b74fed3b8d938fd5f2e68525f6d49243f2f33ed4f9db63e0db606b80bd4"
    sha256 catalina:       "7d19825e56b4c035d4faddf4b63d9c5b5ae437b277026a2bb3fb9cc664f221b9"
    sha256 x86_64_linux:   "6ea637f9b6b17168bbcd63d9065b279485762585a35753050c384c18ce07093b"
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
