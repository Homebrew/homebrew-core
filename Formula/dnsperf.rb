class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.2.1.tar.gz"
  sha256 "c073e391e681625eb8c7f308a5940435f8e2ec53f615b4e259625024e270dc5c"

  bottle do
    cellar :any
    sha256 "22f01884926cf1d2424e9a75cde834cd99e6b100cefad5248246e2bc1fdee51d" => :mojave
    sha256 "463016f4de498c5b1e0ce603cb3cbc04106579992fe3973d638f33dc744c8cfd" => :high_sierra
    sha256 "0a41577c6848154de2562bd8a78c88a018a8279feb517a7c67139b1d6c2f2c1d" => :sierra
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
