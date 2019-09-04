class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.3.1.tar.gz"
  sha256 "ffefdc4610943c645b181d26843842d4890721d4da09ebb19aa7c8a5b7effd8a"
  revision 1

  bottle do
    cellar :any
    sha256 "efac588a5d624d19ea80cca7c8f5faa656bf8ad378caf11404308b398befb569" => :mojave
    sha256 "b99bb0c80bf2dd235d3458b73b46604140198f99ed2f431c23fc490a27e28d10" => :high_sierra
    sha256 "8ff4200b94c788ef485b6df61bb5fd8873684d7aee5e01635e0ce6ad732f44e9" => :sierra
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
