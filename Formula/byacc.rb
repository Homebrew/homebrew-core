class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20230219.tgz"
  sha256 "36b972a6d4ae97584dd186925fbbc397d26cb20632a76c2f52ac7653cd081b58"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c27d3b4306a3f6da130924168f2547747dfba84c53b25f54c9f91909392eab2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4d6ae246c3e6dcac5ecb016d4c649631c2ab11a426e673158d003a74715f3e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49bc1409746ef53be72ae0984ec561ae5d80cadf235999f0785543e75f26084d"
    sha256 cellar: :any_skip_relocation, ventura:        "ccb4ee0e9db64ae04cffeac6726565c94e67d17de0c73380053f198b29c812dc"
    sha256 cellar: :any_skip_relocation, monterey:       "d4fe491d44ce577bee9175373529edb9e935e75c97eda16898608032c8c76307"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c73f59a258c3bb72639af19f6a40e57d50153aab96b229227252d87682deb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "497cd593142ec405b5f3515589e6e4cb8b50479a8f1a3ceaa99bdf6d00f70424"
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
