class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.8.0.tar.gz"
  sha256 "d50b9e05d9688a7b5906447cdca87bf1d8e100b5288e0081db6c3cdd0fea19b3"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ed9838c9f524357a9c35a91df072098140af8f20b5b55b818cc91350e1537d63"
    sha256 cellar: :any,                 arm64_big_sur:  "9058dc5367702b9bb5ceb1fc417a34f60344eea124384beca9c75b333351265b"
    sha256 cellar: :any,                 monterey:       "618fbfd1a0c7491c2c50910d4c0cccedbf1ea38d22afff30c0d881b0ee004332"
    sha256 cellar: :any,                 big_sur:        "33f81adab77f7d988a927144bdf77f5090d3489e0d3ef812f3b273c74cd07e25"
    sha256 cellar: :any,                 catalina:       "88b0ae4ee57e39b8e87f97d5b1aac1c12b5f44e744aad1316b45619781e25b34"
    sha256 cellar: :any,                 mojave:         "4d9debb3fb6b0a43620a205abf27d083d6b731e355afcb8c55f23812347f7aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cae9a4ea9e132cc17ab2c378c5e12b7c1159edf536dc839438afdbffb43bb858"
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
