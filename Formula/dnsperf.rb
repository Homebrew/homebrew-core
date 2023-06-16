class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.13.0.tar.gz"
  sha256 "a31caa1899c67f35f28b970abe1f31f1d9c6b1f8b20ea24187ca1a82baac53cb"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "62d7cf53e9c51b4edcf612ac73297fcb44e4160c85513f15fed30ded784861cc"
    sha256 cellar: :any,                 arm64_monterey: "4f5bf82bc29895eda6ab68fee366e04cc3946b14163839608fa790dd88f9eca4"
    sha256 cellar: :any,                 arm64_big_sur:  "1df5187c9fdebe7c44640fab835062e33b29cc52b24e0e865983f42c88d245a4"
    sha256 cellar: :any,                 ventura:        "f99502a6c819d007012ba51266896130edfc477866bb356b3ef83923ca370045"
    sha256 cellar: :any,                 monterey:       "bfca7728a02e2267d40310de79cc53b388c48de73106385bf46eaef6fdc3d2f9"
    sha256 cellar: :any,                 big_sur:        "bee361fbf3f07ff4e4ef1349496dc2a347514e1edfbbab6c0eef9b017f4821f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dfa2edc4a4d189e3611c757fd91b9fd1f4f583799c79a146b8e536c72f3915c"
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
