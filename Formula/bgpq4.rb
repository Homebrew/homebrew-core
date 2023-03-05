class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.9.tar.gz"
  sha256 "214260e7eb79f4e04cb4a00770483f645665536f72aaf8bdee28c4df4ec8b947"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "083e540cdc3f92f8d5a47b056f2218981e353b3beb760d38a889b996d9c0f695"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3287e28cc992c8522c4a6b0a563dbd2fa1fc2a56240c5b9de8b3be5b9d279420"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6d1ae10c2d7507d80de2a192ad563c2bc251087167ef2580a67e7297572d347"
    sha256 cellar: :any_skip_relocation, ventura:        "3f97de1deb16849f9988c0d3b497edca04b5d88f162667209b0897045524f481"
    sha256 cellar: :any_skip_relocation, monterey:       "9aaf0e2cdaaec238148b4c76782588ab26374bf3a5dfb69bcf553d1ffb8ac304"
    sha256 cellar: :any_skip_relocation, big_sur:        "e387c4aaea40481a2daceb404028f39ab5fb5ce4562e59e5dc1bdcdf4457e629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e62fdaadc3e157e8c0051c5b3ad5433fe17ed66386a06c46fe4652709d0c9129"
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
