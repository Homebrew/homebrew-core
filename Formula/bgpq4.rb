class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.4.tar.gz"
  sha256 "db4bb0e035e62f00b515529988ad8a552871dcf17ea1d32e0cbf3aae18c2602e"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "472affd5c3f07a28e6bceb6e3e37fd34fd32f161468790172806f235472a7db5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a59f7bc0a4f0fb911f6d464f85d3c19b80da94bcc5c50188825f1e9ed6c5208"
    sha256 cellar: :any_skip_relocation, monterey:       "4ef13912e984cef2bf3f9a4f97cf2bada9104f26edebccf2b792416b6de0f596"
    sha256 cellar: :any_skip_relocation, big_sur:        "370e39599aad59b426c7eac54dc5bae8960ee6d82f494a11191f0d1ff88b95d3"
    sha256 cellar: :any_skip_relocation, catalina:       "b2549810cc41e269f260ae42096a0b4b3051d10b44d7c94f40d4d26d9d84d73b"
    sha256 cellar: :any_skip_relocation, mojave:         "9f8ab5fddb0e06cc1ac25d373d9bc0c8b38ebded71b36b8ef7375c51c77e91c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac7b84ef5cd3c74b7087488d7b9d3d72ec2c89a6498686d53e2873397448c904"
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
