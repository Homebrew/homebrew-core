class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.5.tar.gz"
  sha256 "6650494caff7ac78b92e0b416437b1726d607c2946f19aa4b9ec50176855ea60"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "661b019ccaa45509b977970dd4f19f7de9c7d2c3405c758d732d877241f254ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa0ff51e29bc8f44e607c150f41380e7b415587bce37caab6003d6165511c0e6"
    sha256 cellar: :any_skip_relocation, monterey:       "ac3f716dfbc06d3de48a9faee3493d499a07910334334304e57724a26c384044"
    sha256 cellar: :any_skip_relocation, big_sur:        "43002b4fd735da4c59b5fdc1ed8d2cef5c8d62aec092d8761e52a0a4eb7eec22"
    sha256 cellar: :any_skip_relocation, catalina:       "707d2e0d0dfdb6d71aa1316d7569c4ddcf950e82d5bec8d4fead9f5408fd4d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a2f0619b1d8bcfcce13b861b49f9dbb9d0a4ab24e04f87e60a95c6c353a395"
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
