class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.3.2.tar.gz"
  sha256 "292bbaeb95389b549a91f4bfc7faf8062326ef75a0382e879ca86cdfe71df408"

  bottle do
    cellar :any
    sha256 "7c89a8d743a3a62653aebf2d0a6102991a88efa5fb0b8743d425745b2cc60e2a" => :catalina
    sha256 "8901054afed6de33bdbbe8eda68f9238f0ac3915acd5ee319c942acae741841a" => :mojave
    sha256 "f67934e4c9b06aafd7220815911a6fa27e430ef0add19b5fe8cfda3adb9dcae9" => :high_sierra
  end

  depends_on "pkg-config" => :build
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
