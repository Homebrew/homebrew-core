class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.7.1.tar.gz"
  sha256 "9b4d72aab6713ecab6946ea3d4b69ec694c5749c3a115fc4a006e989c8ed4875"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9058dc5367702b9bb5ceb1fc417a34f60344eea124384beca9c75b333351265b"
    sha256 cellar: :any,                 big_sur:       "33f81adab77f7d988a927144bdf77f5090d3489e0d3ef812f3b273c74cd07e25"
    sha256 cellar: :any,                 catalina:      "88b0ae4ee57e39b8e87f97d5b1aac1c12b5f44e744aad1316b45619781e25b34"
    sha256 cellar: :any,                 mojave:        "4d9debb3fb6b0a43620a205abf27d083d6b731e355afcb8c55f23812347f7aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cae9a4ea9e132cc17ab2c378c5e12b7c1159edf536dc839438afdbffb43bb858"
  end

  depends_on "pkg-config" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "libnghttp2"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end
