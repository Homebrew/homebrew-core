class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.6/cups-2.4.6-source.tar.gz"
  sha256 "58e970cf1955e1cc87d0847c32526d9c2ccee335e5f0e3882b283138ba0e7262"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "5097ac6de3fcd9c2da3bd4f09c01714d73761c0399c8695592d6534cdf23c6e8"
    sha256 arm64_monterey: "65d0e5f4ba75438cca64d341adca30d9d1bfc4867358421cb74fa375b94a7e69"
    sha256 arm64_big_sur:  "f0b6128fddf54ec1069c32a9b83788457f377a0b09dc256b6464f4f2161560ae"
    sha256 ventura:        "1bd88a31dd6fc3292cf4df626b6531c05b1a35fb35c4e219950710df939da85f"
    sha256 monterey:       "9f9324ad8a39f8d3d4863a044107290e8933b9e8b091dbe5d32bc5d490db5c35"
    sha256 big_sur:        "f52e62e443641e19a167ced1e76969c45486a513b4fed8bdc33cc80f1203dc36"
    sha256 x86_64_linux:   "841f335903bfdd8a6e2e4fc4db73a0f261f581d59bbd3f3a98acb5e83507f699"
  end

  keg_only :provided_by_macos

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-components=core",
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
