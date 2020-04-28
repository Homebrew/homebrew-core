class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://www.cups.org"
  url "https://github.com/apple/cups/releases/download/v2.3.3/cups-2.3.3-source.tar.gz"
  sha256 "261fd948bce8647b6d5cb2a1784f0c24cc52b5c4e827b71d726020bcc502f3ee"

  bottle do
    sha256 "028330028dca9194605bdf6ec807b413adae82b1491bb69cbee64d31fc04a6f3" => :catalina
    sha256 "4fd5c5705dfb551e9fd5091f63a69d985bae05bc0b29fb253c9877138b254e7b" => :mojave
    sha256 "932ce69ebe900f3e307939ffb475a1d2d3f46d079b3c6b5238385051bdc110a1" => :high_sierra
  end

  keg_only :provided_by_macos

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug",
                          "--with-components=core",
                          "--without-bundledir",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/ippeveprinter", "Homebrew Test Printer"
    end

    begin
      sleep 2
      system "#{bin}/ippfind"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
