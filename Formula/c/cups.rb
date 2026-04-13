class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.16/cups-2.4.16-source.tar.gz"
  sha256 "0339587204b4f9428dd0592eb301dec0bf9ea6ea8dce5d9690d56be585aba92d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8424841fac4c8cafb8179f5226928bfb2fcef71860f63dc6fa44d661e351ec63"
    sha256 arm64_sequoia: "32622111c9f460aa8be40ec7231c93521376f2fe260c505f680dd4cde3481659"
    sha256 arm64_sonoma:  "831347b2bacc22aa8c4b12a2150d58ee8fd86985ba649845762a62f4a5a4d7ea"
    sha256 sonoma:        "56eff0f29e06651f360fe67b1879137b50239bbbad6ea67123f5b706b4912070"
    sha256 arm64_linux:   "573d09a9645a35852d77d7f134a810898ee2ff81333f6ecebe811ee92016100d"
    sha256 x86_64_linux:  "4f8fd899d1f1801fe74efed50f91e52a16287d2e60d2417a58d66e97bfa3077e"
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
