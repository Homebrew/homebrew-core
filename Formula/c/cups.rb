class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.8/cups-2.4.8-source.tar.gz"
  sha256 "75c326b4ba73975efcc9a25078c4b04cdb4ee333caaad0d0823dbd522c6479a0"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6a422caac35339a78ab915377420845691c996897ee70f263a55441adce3ff4d"
    sha256 arm64_ventura:  "f1b35ba4669add4508510461a4bd0a9c0cfa5b42443e56a139f6f3a9e0f186c4"
    sha256 arm64_monterey: "878d53ad48759782369cb1572f3b5add05497eed519397d8f11777eb873c4b96"
    sha256 sonoma:         "6e848623922fe67279d3522d95c24bf3eabaa15b6c1c7d4374d07b34f387eba5"
    sha256 ventura:        "298efd746551946e1f84dd77c01fc37da3a673fcc436c26ec601c43e0678f7cf"
    sha256 monterey:       "9cd6e7ba8147debb860e2046aaeee087e7d3b738829124135dc110c3193965ec"
    sha256 x86_64_linux:   "c02a0668434c3e2ef37c35a62f23c6e9f51927067ab7ff7c05ea9ec868bc3e58"
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
