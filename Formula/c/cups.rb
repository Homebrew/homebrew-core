class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.10/cups-2.4.10-source.tar.gz"
  sha256 "d75757c2bc0f7a28b02ee4d52ca9e4b1aa1ba2affe16b985854f5336940e5ad7"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "58df6136f3aa5f3a1d634892ee4b742e5170f6aaa7b91ab8ca041af5baf5cf54"
    sha256 arm64_ventura:  "bd58946f6e800d91d6a08cafe8910941885563a70855356ff21777bcd7f17ab1"
    sha256 arm64_monterey: "2846fedb1ef7d4333ea499a08fbb267507633089d5152a68df6c07ca90709889"
    sha256 sonoma:         "fac480f1a065d47433e18718383686596d7b646902afa45b14fd50ee7c61f63b"
    sha256 ventura:        "67251db05865a0bab70a1d3ad170eba578b031b034b82012b5c78dd49c37cfbf"
    sha256 monterey:       "3c488b7f512b7122c274465d849b023bb1c906c57d46ef3a60ee52fd5510aa15"
    sha256 x86_64_linux:   "6a3a570c6a30876b79da8c94e64f0e75a523a24ee6146adb7cc4d4cb8835db9b"
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
