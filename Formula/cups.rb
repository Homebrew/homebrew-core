class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.5/cups-2.4.5-source.tar.gz"
  sha256 "9a404de55f74525b0a6851df0cfdebfa1215aec0e7c2f7be6b9b09b6916fb000"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "a9d75d19c28df2dc0e2e5e73e878811fa71788ee3afac89610796a6e7476b4f2"
    sha256 arm64_monterey: "c7bc577adcaa64a33280b92047c209ec02c612a5ff9749a4f8382bce591228f8"
    sha256 ventura:        "ef33fead0baf4c064379cf709b46f6b409ef03a871c4f990ab6d11b6726ab938"
    sha256 monterey:       "3115cdcf11c881d0fc420da4780c2724280aba4c22eab64513dd562dbda8c547"
    sha256 x86_64_linux:   "30dba08478c1118cd969ae21c707b5c3be7b45476b3359c6036015834db679de"
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
