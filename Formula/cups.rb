class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://www.cups.org"
  url "https://github.com/apple/cups/releases/download/v2.3.1/cups-2.3.1-source.tar.gz"
  sha256 "1bca9d89507e3f68cbc84482fe46ae8d5333af5bc2b9061347b2007182ac77ce"

  bottle do
    sha256 "8fa7332f0bda6fdc9b08692375637675d422d23712835e8c04110cdeea79531d" => :catalina
    sha256 "19697995a80b35ff96a361ce5f309f5c2972fe512079234e60f0affd6ee7bae3" => :mojave
    sha256 "17e8402cc38c9ccf7c9faa31b7922ca52aa8f6f79b8131ee61324f06c3d66b0f" => :high_sierra
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
