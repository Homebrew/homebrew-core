class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.20/cups-2.4.20-source.tar.gz"
  sha256 "ab4d9cd7f3e58060091d2b24972223d6401675f11c49b65abf4f6ef31dea22ff"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "5a727441c523de179b6277404be515908bb4f778a1f967493502e9554411ffef"
    sha256 arm64_tahoe:       "45c907c232389a65d84a2178f8f84e8c0a3d831066593a44da3324843759cdf3"
    sha256 arm64_sequoia:     "0e9d882e26f6282def22c4a4dfc716c7f222b069ea98f7b1ee74dad0dfc2bf3e"
    sha256 arm64_linux:       "08e6865b88ebee88ffeee1491c23dadbcdba000bbc6d5ff5ea5fdc33c2f3cff3"
    sha256 x86_64_linux:      "e6b60a0d43398e4cf2356c4f930bbc010ffe1b7e549d2544f2a24c035f2b345b"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix builds without DNS-SD support, upstream PR ref, https://github.com/OpenPrinting/cups/pull/1740
  patch do
    url "https://github.com/OpenPrinting/cups/commit/23a183b63a4c94ae7cd0f36c63ee7eb905be60fd.patch?full_index=1"
    sha256 "8168c6048065abea242af383171b08b4b16b58d7b9831819f75b05c0d52ae0c5"
    type :unofficial
    resolves "https://github.com/OpenPrinting/cups/pull/1740"
  end

  allow_network_access! :test

  def install
    system "./configure", "--with-components=core",
                          "--with-tls=openssl",
                          *std_configure_args
    system "make", "install"
  end

  test do
    port = free_port.to_s
    pid = spawn "#{bin}/ippeveprinter", "-p", port, "Homebrew Test Printer"

    begin
      sleep 2
      assert_match("Homebrew Test Printer", shell_output("curl localhost:#{port}"))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
