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
    rebuild 1
    sha256 arm64_ventura:  "5d0ea4e86f40eb3650034723cbe4786a0accca7f5904e710840ac52ec463239d"
    sha256 arm64_monterey: "a360d94c115ce0cac86323656ff6f2d616677c896714b45ee8a2c649c9656ddb"
    sha256 arm64_big_sur:  "225203fd3c07bfc63c8f62e1b96b0280f8c46ae2a89e5b71e6601f7ac52c0d23"
    sha256 ventura:        "0a97f59205a79c3a6d7b7c9c24d7785771a47006fa163b24a425d889a66c3973"
    sha256 monterey:       "89fa9e072be7515c437434a26730ec894667e1b119f05a98fbe7886199813ee6"
    sha256 big_sur:        "11581b74fed3b8d938fd5f2e68525f6d49243f2f33ed4f9db63e0db606b80bd4"
    sha256 catalina:       "7d19825e56b4c035d4faddf4b63d9c5b5ae437b277026a2bb3fb9cc664f221b9"
    sha256 x86_64_linux:   "867dfd79e4892f864af88677c5ca2ba33b6623ec648d8139bcb5d55e004275b1"
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
