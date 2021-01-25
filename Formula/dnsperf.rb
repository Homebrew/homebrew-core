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
    sha256 "cae2449d62f2b16f38c0fcef4616c7c21d3fdcbeb4675af9a2a2ba4a84c05d91" => :big_sur
    sha256 "b91cc6c7f9444ba48bad014bdd7c02521fb2f967dad69168c2297f3e45539111" => :arm64_big_sur
    sha256 "e32893da68dd62e5b22482082724a04999ec02a18830530a9491bf0ef15c3b39" => :catalina
    sha256 "53cfbe6fa7f93a22cf0bdd6aa5cfe91bb7d3639ff72c809d27d4fd08c8e06d12" => :mojave
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
