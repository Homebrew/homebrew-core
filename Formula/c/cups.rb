class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.16/cups-2.4.16-source.tar.gz"
  sha256 "0339587204b4f9428dd0592eb301dec0bf9ea6ea8dce5d9690d56be585aba92d"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8bd91492767ab03c60cb845a39933ca79bf45b689c1a243c8966f0370d5752fe"
    sha256 arm64_sequoia: "f9584d88da0c0f3ef3e7e679db89fd9e82018436bb209f65896b928b7007b35e"
    sha256 arm64_sonoma:  "7f36f681ac44f7f8beb74703f61ba5a993072f49f341de010ed29bfa423ec8f0"
    sha256 sonoma:        "e27cf96facf5af120d44cff0eef8f116d9b301ce177d4d0c4eeb79f1ca6c4f48"
    sha256 arm64_linux:   "b44dedc12c393e914d12b22dfc2d231f2b62fd6a2769442b02be6db66f1bb6cc"
    sha256 x86_64_linux:  "791727de4166cd8213a9acd8fe76492660245eb98481c405c6fb55a017e7054f"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

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
