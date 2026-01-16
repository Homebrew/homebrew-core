class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.15.tar.gz"
  sha256 "30fea8d6274af6e3fba30497b977a924c79de326ae2211e490362dc7282403d6"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "13894eb38127e80cfaad864959908e443b93920516fcaead469ca88ae882cd79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fe14d23c24fdc8be81ab6e291e8483e66a1c022939ec06603ce326da41393b78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67e3fce3c562c29ba7ea02ab532a49cd7d3be4a9a3f54db774235a2d9b68baf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ef09ee512c779d161c92064f799d213300a00a72ce268f02b05652268afdf53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d508f0b6fbf454288a745c659235deab354cbf63c1eda932dd589827b8ba3e24"
    sha256 cellar: :any_skip_relocation, sonoma:         "054b4627828599a8f3518c4cd47914f895b7c652b537cef8c9115940fc6dc3f6"
    sha256 cellar: :any_skip_relocation, ventura:        "6b1e57ac908e87d8b348fe0d2dc70fd0bd5c178caf8dc5a041bad4cd48088ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "0d4dfeaa2caa2c39c6daa71d8f679fc18102c1c13caa14faa984e956eeb6820f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "eacb29c2e404c6c58efffd6bbcaa51a229a2ef55ddb83938737e2245c4c6fdd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1170e29b65fbd8f5eacb9ae2fa7ed9a1cf7408ef35095c17c95e38635cebb4c2"
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
