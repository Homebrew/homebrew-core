class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.16.tar.gz"
  sha256 "c228e44bb62141851e7213563b5800b9b7b56d183f71563d5f0fe1ecdf57709e"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5e745990029980ccf23bea3b07c88a650c2cec39997890c3e8fb9a3777caa10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38a03fd0d53b7b6a94732f1f0e41cff6212af6508ecb118cfe8b77eeaee1c07d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e6f9b0820084e8c9559a1f26a4052bd216243014844ca761ebf884ae430ce26"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9f929e5bb0f2b14e82cb4b67e8078d642f73454397a065a709f8d9db56f6fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c6b3f5d3144ff448bba5c199dcf9e1eb2f46d1ebae9aad3cf85b15a99a4cb8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59e573f78602c2f9dcaf2418602fd0cbd570341d51f545179c1a49fa4b8044b4"
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
