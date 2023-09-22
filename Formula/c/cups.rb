class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.7/cups-2.4.7-source.tar.gz"
  sha256 "dd54228dd903526428ce7e37961afaed230ad310788141da75cebaa08362cf6c"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "643eea6223eb736d6f3595e92539027c1b628227a1638367dd924fe41f5c3781"
    sha256 arm64_monterey: "58309d40f9b93952534d8d8aeecf930a1874b6df5b73508c0e3493bc6ab9fb82"
    sha256 arm64_big_sur:  "7ab8cb68128235e0e8b8dff6c2d7d75dd7d06da9365aaa54421d42155ca77499"
    sha256 ventura:        "d6d37503ff0f322c238a5f177c4723d77814327d6b39ae2b27c05b679e4dd822"
    sha256 monterey:       "0b1aead51e1611627e4c9f336647476d1ce7e344a162fd3f68e8b4cd24b63ece"
    sha256 big_sur:        "eae22d8b730fcfda7bbb9a776ae5b5e7d1061b00200ec0926aeac030cf24e1e0"
    sha256 x86_64_linux:   "1e35d934788dd9b07ca70d43210a934b17b894a9b4b1d54bc06224c3fa416f19"
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
