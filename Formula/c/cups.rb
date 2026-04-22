class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.18/cups-2.4.18-source.tar.gz"
  sha256 "8fe23bf4905f8889f4bd5ebf375e81916e84754bfc59eccc88cfd7b1e97a741b"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "aaa79339d583996c7e2b2108dd508ac1d431a5c35f424dcfca955a889741a451"
    sha256 arm64_sequoia: "b482980cbf0612a31f57f40464907100aefe3f265dd06a0ae4ffb8b32f9c79e8"
    sha256 arm64_sonoma:  "80cb274ae82d10662fbb4c31552131d54fdc4839efe2876009806a2dee533ab3"
    sha256 sonoma:        "d4bce99df40c9eddce4e35d190b8d3892240887432fc3e067024156bebce515d"
    sha256 arm64_linux:   "db7ebb3d4737f1111e4717a1b554b998e7c17914a958ad7afebe448ab42a14ce"
    sha256 x86_64_linux:  "1b04c6a43a9b0c481b2d6191c5ac478bb39045c24700a7c4258dac3bd5e1f88c"
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
