class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20220128.tgz"
  sha256 "42c1805cc529314e6a76326fe1b33e80c70862a44b01474da362e2f7db2d749c"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3430fbe56c15d37df9c04f65a70e33b9edd4a164e57d7c57711418c9be42200c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b97c8854a810125af12aef0764f7fd0f87ff6a15bb35df9b908b900d6fec0287"
    sha256 cellar: :any_skip_relocation, monterey:       "741dc5e9b6da24cbbc4b20b6d6b6987315303e4c034f41197d58fa865f3315c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d829258da9ba14b1d9b2baf8f184a1e2ce4d1a9cca25dd96a66bb1672816fa75"
    sha256 cellar: :any_skip_relocation, catalina:       "0cb07633c321bceb79924b3b2ff00aaa2e9b22859e305d09d2d0dac292722de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d9e33281a24cefd3024f27f388db71a723da9839e4e60dd8d2a69deeb81be41"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
