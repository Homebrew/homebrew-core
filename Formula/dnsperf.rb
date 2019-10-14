class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.3.1.tar.gz"
  sha256 "ffefdc4610943c645b181d26843842d4890721d4da09ebb19aa7c8a5b7effd8a"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "d264a56c9be9fd51438178358f98d6e51622a153fcf97487ac6fb93ee6f9819b" => :catalina
    sha256 "fc3550c76cf87091bbee3fa47a61970c9f0c862e8beb4ac9702636d3541a1b88" => :mojave
    sha256 "25020eee136ad0faf63126440c93dcc87dd35be1e951cd595247b65e51ed2d39" => :high_sierra
    sha256 "6be4c1270899b5af3526547f7e0edb5a79ac16ca634bab93af3edb6901b9cd6b" => :sierra
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
