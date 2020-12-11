class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.4.0.tar.gz"
  sha256 "25aedca36f5ae15b5b68019741e736579963bdfc9b94235f623cb2deb4ac49c1"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "d1a85f1c052c0ed43c769627d0dcdc558020a988295b0a51e545e9a7d02f0623" => :big_sur
    sha256 "29ce167d9cac25446abbab3948a4de2b66bead70576bca24f13bda51c1d79de4" => :catalina
    sha256 "4cc4b444f46fe98328a3d07c70672b6e963b7b530a10515a02a1f40eab1b2d42" => :mojave
    sha256 "d2bad43d4858579143f5f01aab16ca5fe8a528b3fe81051ee212ebefc7e4a057" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "bind"
  depends_on "krb5"
  depends_on "libxml2"

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    # Extra linker flags are needed to build this on macOS.
    # Upstream bug ticket: https://github.com/DNS-OARC/dnsperf/issues/80
    ENV.append "LDFLAGS", "-framework CoreFoundation"
    ENV.append "LDFLAGS", "-framework CoreServices"
    ENV.append "LDFLAGS", "-framework Security"
    ENV.append "LDFLAGS", "-framework GSS"
    ENV.append "LDFLAGS", "-framework Kerberos"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end
