class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.12.tar.gz"
  sha256 "f6e8f46e0bb9202ca6490f3ac9d9a3db61e2bdab9816e69e5fd8f49f5e6ab0f3"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c92ec16fa2e374d4c6f4cfd746d4ec87c3b3c1deafa7f1fbe7327b89f904adf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1066d38b8a96f8faa447c72d6d2439556ba397bf64a1887819ab29e3fc2a528c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ada910aab5b4de04f8f44d1c1d5a06cbfe3ee4e9da8819cadd31bcda2ffaef7"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc7131c5a10ce00012f71037143a0746cb011c796c2f27837c8a1fef5653a34b"
    sha256 cellar: :any_skip_relocation, ventura:        "ac5431da694c06849383e3709e1e035466db2be8851d49e3e58a7afb07f8fa63"
    sha256 cellar: :any_skip_relocation, monterey:       "1591c13270384e01f5a71fc60bd34933b47c5e53be5ffb5ce3a99113cecea65f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd01314431d270fa008e42dde131924e0e44c229046fd4eda0c500084e30fb8e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = <<~EOS
      no ip prefix-list NN
      ! generated prefix-list NN is empty
      ip prefix-list NN deny 0.0.0.0/0
    EOS

    assert_match output, shell_output("#{bin}/bgpq4 AS-ANY")
  end
end
