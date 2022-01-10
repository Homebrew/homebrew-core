class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20220109.tgz"
  sha256 "98966bc5e6558f5ee50c7b33ee3e0a75efc15dd99cc96739d1ac1af9c1a43535"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2a7d54ef43d59f0f2352ded6608967b5aab2a33915c74e4858c2ab170229244"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9e9305e8f5f140acc5dd6b6a07545ef5bc2a9aac2330e8007d0d124a202dcbe"
    sha256 cellar: :any_skip_relocation, monterey:       "fa94999844237e75827856e9646819ace52c520e7f98ccf4f5617efdddcde308"
    sha256 cellar: :any_skip_relocation, big_sur:        "8de8f4f52e0d1ac475663f828a3356c067c983b31da38638e514f9da6596b45e"
    sha256 cellar: :any_skip_relocation, catalina:       "40b79ddef97e27cb0d75c46f4bebab0d97d6e35f2e1bbfe034770da8bea98430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a949fa6a625842e96aa7f579ce8d2f3049da1ded256610fcd2b46d213ae74fd"
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
