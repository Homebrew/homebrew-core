class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.10.tar.gz"
  sha256 "189e36108651c2009168282011d2e5cc8fa9179f808cf1a621c7d911fcc0e571"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72781fe7521884014ba1be49189b403faaffa5845e5e1919be40f573a072d50e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0781f60fb3de3eef02a0129bf2d5c0185b66df1c4d0cb516a79790f11c2f743e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "797758efe11ecb6f68209fef5461060f13ba46b6b83c0fce470cacdce61bed4a"
    sha256 cellar: :any_skip_relocation, ventura:        "db8174a8ec2c1297bda8c0db0fd962c273e66ca2a622a656c8ed9159ccf12589"
    sha256 cellar: :any_skip_relocation, monterey:       "7649abbc2478299240016cecea553f513889d356e2f8f52bf968f1734bf0c65f"
    sha256 cellar: :any_skip_relocation, big_sur:        "affd6e00ed8f126690866316476dfdf953a07b728c80dde2e926694fb09f5d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e268f6bd8534b17c3352d9e6a83756ee8e16b758d537358046894b9f62ab02c6"
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
