class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.8.tar.gz"
  sha256 "185663160a48ea9f0135d649c43315eac73213bdaa6ec75629f3578c3aee9f4f"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b71dd8c243082c45730559e9e93a5a10b027b4b5b1bb287cef17de1f4e6b173f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ecae71ed5539c3fb699ed10ed4c6af021498b1f632cf7ff2ee4402cb9228e79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "324e60fd788adcabb0845bc07f5fbbe6e166a4c20fdd8cddbad9b976fdc4d0e8"
    sha256 cellar: :any_skip_relocation, ventura:        "382cc4a48dc805f4f848fe162e74e4c7e2a55588106e6f88c2abd110abe66244"
    sha256 cellar: :any_skip_relocation, monterey:       "9ce823d62c783470fd78cd5b08b30b1ec705446157237d30103166565418e0c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "35d5bf15f275327df572a813231cbea5e6567e21323704b43859fc0e31ccf4d4"
    sha256 cellar: :any_skip_relocation, catalina:       "eccc0df0e5bf605b55a344bad6dc6d6c01f41c9b77718efd2be977611feef9c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f31c4f83ea2a9fdecd005695e7a38f623e2ec8bb0f2733c7b71eb466e29a36"
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
