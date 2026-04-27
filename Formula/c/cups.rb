class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.19/cups-2.4.19-source.tar.gz"
  sha256 "820984b12a67f98705785aae2dd1347fe0ac097828001d4583ff64574aed6389"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d955afb80fe37ae3abe24508266366e3a478e44f8c9d7cc2ef1f2d9a4731e6cc"
    sha256 arm64_sequoia: "2342daafe9e22f6a38607caf91e3179c7a2be986a383f5d6dddeb474ab002cba"
    sha256 arm64_sonoma:  "9c026b11d6639e63bfc936a8e3c2a94f37ed85091fadb89deff2cb0c9fd76ba2"
    sha256 sonoma:        "b9bf43810cfc359937f058290c785f409466403a9def318bdaab9bd93b839f27"
    sha256 arm64_linux:   "e33032a47e3f727b4a61c5470f661b65335dd2e9a08b978789eab8efec25a196"
    sha256 x86_64_linux:  "339e4513038a7866df092989c8f03bb5139be6287a4544e075d208eccb968c0c"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "krb5"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
