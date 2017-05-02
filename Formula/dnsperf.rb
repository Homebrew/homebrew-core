class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://nominum.com/measurement-tools/"
  url "ftp://ftp.nominum.com/pub/nominum/dnsperf/2.1.0.0/dnsperf-src-2.1.0.0-1.tar.gz"
  version "2.1.0.0"
  sha256 "64b5f0a680e1ad60bca5fd709f1a9a8404ac2fd85af6138bd22ca9a28b616e0e"

  bottle do
    cellar :any
    sha256 "022ff860326489a63461893dc00c22854fea6fd63949b48ae44abf37e539c20b" => :sierra
    sha256 "5e605b056442f7c84a1f7b826ae3fc0e113d12b8ab2174371e004c79acc4336a" => :el_capitan
    sha256 "8d18fb864b8cb9fd3624e10d178fc11d9bd569863ca9e94ff9fd7afc0ee91afc" => :yosemite
  end

  depends_on "bind"
  depends_on "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end
