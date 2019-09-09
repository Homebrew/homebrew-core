class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.3.1.tar.gz"
  sha256 "ffefdc4610943c645b181d26843842d4890721d4da09ebb19aa7c8a5b7effd8a"
  revision 1

  bottle do
    cellar :any
    sha256 "72afeed7355b910a9e45ca962634901475a1c3d6a0ff118e240744cb161f6d53" => :mojave
    sha256 "0335155c2530cc329914d4c85ad6a5054ce13cab87b18da45280122e9d316d99" => :high_sierra
    sha256 "672cf1e1460b15d2cd1b10adf358f1ff9ebb887a0cc7c4c17cdca7ac8a0e54bc" => :sierra
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
