class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.4/cups-2.4.4-source.tar.gz"
  sha256 "209259e8fe8df9112af49f4e5765f50dad6da1f869296de41d6eaab1b98003cb"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "085269454cc716e101433dd921ebbff219f13c24f916167cd164066e6c645d2f"
    sha256 arm64_monterey: "93593280aa814ae1a9ca3f6af3d3ebd8ecfc20ca40b2ab5dd1c959af83c40bc0"
    sha256 ventura:        "869e318ca1e31c0d15689c1ca4cb0eb2caf044cdd9f8b7cc6e6954868bf03076"
    sha256 monterey:       "603084e6b1496e3a9d07ebe308590dc83c58bb278e985906d2e064acc3fd51f8"
    sha256 x86_64_linux:   "abf0049599c119a74e639e7bbeb2a8297fb7b24509cb2aa30630aa6269e2f159"
  end

  keg_only :provided_by_macos

  # https://developer.apple.com/documentation/security/3747134-sectrustcopycertificatechain
  # `SecTrustCopyCertificateChain` is on available in monterey or newer
  depends_on macos: :monterey

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnutls"
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
