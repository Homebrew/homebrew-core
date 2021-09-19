class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.7.1.tar.gz"
  sha256 "9b4d72aab6713ecab6946ea3d4b69ec694c5749c3a115fc4a006e989c8ed4875"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "348a04545e3345fd768f6f8c16cbc952547f458e50c6800c8ba48a1fb5242848"
    sha256 cellar: :any,                 big_sur:       "130c06cfb1bbb0fee4dd985ec258f7a4b458692e1935b70635d0f6f9677dfa1a"
    sha256 cellar: :any,                 catalina:      "63b074a7b0417853d711728a1cf512d8beb0e380bedbdb74542762f717d15ba9"
    sha256 cellar: :any,                 mojave:        "9a254bee84416f31a8166f334b6f3f9c4fe387432ec967e643c29058133ea38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e73f40d98bf9f5e2c0e084697d1fb5b57efcd039ea417e91fbae95d498ae263"
  end

  depends_on "pkg-config" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "nghttp2"
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
