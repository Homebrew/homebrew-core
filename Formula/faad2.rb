class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faad2/archive/refs/tags/2_10_0.tar.gz"
  sha256 "0c6d9636c96f95c7d736f097d418829ced8ec6dbd899cc6cc82b728480a84bfb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7d3ed82ad0bc48a71b7341db0d578545bc9fcdd4ea084b4e651d99319c1e7b63"
    sha256 cellar: :any,                 arm64_big_sur:  "8032f53b871aa9c01950efd796f73f66f3cbd514e5078a0a81cf7f36e42723a8"
    sha256 cellar: :any,                 monterey:       "fbb0d45e57a091f43f049152b505525a060f4a15c65f455769f88adfafc4e46e"
    sha256 cellar: :any,                 big_sur:        "3b213d8ff392515c908a505c0ec902f195fcbd7a8ae470896a0a4ed0080a5445"
    sha256 cellar: :any,                 catalina:       "efc7c8b92b7411b12fb4f63ef641f92d2278b212f49614b7322449dcd24971fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "720a60fc65bf50a3645009ab1e4046f897ebadfc06be17e84e00eec0dfd49a56"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "infile.mp4", shell_output("#{bin}/faad -h", 1)
  end
end
