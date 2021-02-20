class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.4.1.tar.gz"
  sha256 "3debcc95c2e70b5fe866b0f1eacf3d0f586fff2f3083e97247420b2f08e772e5"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0109d601c9e40ef0ef18f62dad36fc3b2edb8072e5f1857e76d70353565f98f3"
    sha256 cellar: :any, big_sur:       "c5b2d2a55ba7b574b3f02e36b9cac637aef6af943c7a9ea28c22277479fb7de7"
    sha256 cellar: :any, catalina:      "3d8a1b6fadf78d65bae61247814a6a5cd75d66f06dae1d126a6269ed9e045c5b"
    sha256 cellar: :any, mojave:        "f37e5ca6b5e5fc6f427fce4f9ec5942f670ef5548ec9f3fbaf8939cbf152cea5"
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
