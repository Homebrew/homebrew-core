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
    sha256 arm64_monterey: "bdfa3cea4b54fcd1445143491987f2540dea0e6ace8d6bd67b95e0897c5fcfca"
    sha256 arm64_big_sur:  "a4b7080abd42693217f8bae06bcda8bd1272a056ba0bbfb6322a5d0ba1f0dbbe"
    sha256 monterey:       "17456a01b543aa9524a0df4681d72cb068e706dfb08c224aac111cb24297f5d0"
    sha256 big_sur:        "662c3c00634bc90e607f6de3a82aa795635f1fb3a02e570a5caed2f226c929bd"
    sha256 catalina:       "3aa5776cc5aa375901ec0059404f2afe86d6b51d7ad4e5538ef9df47ff51fa55"
    sha256 x86_64_linux:   "8cdccf468e13c5245721ee443f7af8615fec4d4224aefb7cc35422c06c5257da"
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
