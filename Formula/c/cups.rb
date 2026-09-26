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
    sha256 arm64_golden_gate: "5f59ea1a3f8f065f8ecfb09162f335d5602e48e1898803578f99ec7b6b05f3dc"
    sha256 arm64_tahoe:       "ef58fb5920d8f32ec71840a0b5e9ce0df756be5e00f7e20562bf68a3b2c637e8"
    sha256 arm64_sequoia:     "96aa911bc2a107bdf3de8b6488363ab9c92e86f0c30691f411ac9e8e8230d62c"
    sha256 arm64_linux:       "0e8320ed95664408f90596bc0e043fda06d52606aa3e323bef6e6be48b0f5a55"
    sha256 x86_64_linux:      "650c439a2c171bf498999727da56298900c677e87a4b995991b7ddace0397841"
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
