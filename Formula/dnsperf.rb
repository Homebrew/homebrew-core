class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.3.0.tar.gz"
  sha256 "f9f1a0de7df51094b9edab03de88f3370a2821a48d74a274f781642db5497a0a"

  bottle do
    cellar :any
    sha256 "253eb944b3e0d302b166f41a35219cd46f35ff7781caa62a790b251a5851ae08" => :mojave
    sha256 "2c6821d0479ed73fddb44e5071357abc103a48074cea46142e30d68e1ecdc5b2" => :high_sierra
    sha256 "90e1a31d325769c4c5fdedd31795f3d6d922bfb8b03deae953093762861e585e" => :sierra
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
