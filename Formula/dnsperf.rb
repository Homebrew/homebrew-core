class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.2.1.tar.gz"
  sha256 "c073e391e681625eb8c7f308a5940435f8e2ec53f615b4e259625024e270dc5c"

  bottle do
    cellar :any
    sha256 "05d63b1d7b94e6fa4cd9d201ed240d8254ee78c5c9ffcc74ef5942800ba33e80" => :mojave
    sha256 "654185e3cd66f2ba80a14e2018d55bdcbd0a8c2f2b2cca1959f9358f2b67c2f6" => :high_sierra
    sha256 "022ff860326489a63461893dc00c22854fea6fd63949b48ae44abf37e539c20b" => :sierra
    sha256 "5e605b056442f7c84a1f7b826ae3fc0e113d12b8ab2174371e004c79acc4336a" => :el_capitan
    sha256 "8d18fb864b8cb9fd3624e10d178fc11d9bd569863ca9e94ff9fd7afc0ee91afc" => :yosemite
  end

  depends_on "bind"
  depends_on "libxml2"

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end
