class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.15/cups-2.4.15-source.tar.gz"
  sha256 "eff0bbd48ff1abcbb8e46e28e85aefaffa391a1d9c4d8dc92ab3822a13008d7f"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6e9c17323bfa92ec1558504bb7866b2c699aacf205af47fe9dbc8021b832ca9c"
    sha256 arm64_sequoia: "dc17802c832264cef94084c2435a6f8819884a578870aa59b1d864ce2b388817"
    sha256 arm64_sonoma:  "da2bdc2434b2d4cabdaa7b600224a2023b627e40ec0b547ea39e024fc6e7694f"
    sha256 sonoma:        "551111e8afdcfb1b9ad6167e28f2c0bd4503ed1cc80ea35542a0e1df62dcdea5"
    sha256 arm64_linux:   "360f33a3b957dba77dce4ad086857f9b32b4e07cb5024a83c63824caecf90ee5"
    sha256 x86_64_linux:  "cdab20781d2583c10105197ecdb1bada1a569f1045a4774c324c3e46b0af289c"
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
