class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.17.tar.gz"
  sha256 "f420e82da10b991399203e01ea2ea3369408ac367425bf48a2e0af145b96bbf4"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "529c8f5d2cfa881163af8e10660e9ac72bf05152034dd0326924b7de1ff90a6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "469313e0a6b2553d2d7a8f50aadfa0e5250fe81529c2d03247abf5e77194bafa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0fec7a9018f00cbc8321a856081ebe8fe9c700fd318116bcb3ad0d1b9cf4117"
    sha256 cellar: :any,                 arm64_linux:       "90677f00817c4f91f89c1f6363746d226501be2416847ba67f67d736f8792e7c"
    sha256 cellar: :any,                 x86_64_linux:      "2c26da48ac4e7ec1106de2b0d6f8b1ad33b4ee6fedaf3afe5c0c195251b2751a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  allow_network_access! :test

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
