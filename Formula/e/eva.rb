class Eva < Formula
  desc "Calculator REPL, similar to bc(1)"
  homepage "https://github.com/NerdyPepper/eva/"
  url "https://github.com/NerdyPepper/eva/archive/v0.3.1.tar.gz"
  sha256 "d6a6eb8e0d46de1fea9bd00c361bd7955fcd7cc8f3310b786aad48c1dce7b3f7"
  license "MIT"
  head "https://github.com/NerdyPepper/eva.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "244898ede20bf08ca17f739fd850699b99e8940a010007f8084d2ad3e6b6c12e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d600eb8e8e278101a902807941e3417a5508bb90352ddaadbab09b889b6499f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "967cc1144edab1e5632c3105e84b588121dd7f211c056ffb9795ccf35fba2449"
    sha256 cellar: :any_skip_relocation, ventura:        "ad7e7d66530d8aa57fb9d219e069faebf84ac9357d7c45d937547efe25c267d4"
    sha256 cellar: :any_skip_relocation, monterey:       "16b3a5a30dc5aeb1a91c1ff219924f758df52eb763c33dd713a54487d0e5a309"
    sha256 cellar: :any_skip_relocation, big_sur:        "97fc21bb2c1e5e7094c8b1f5e073271845b3d54928a4a41c15063aeb6a102cef"
    sha256 cellar: :any_skip_relocation, catalina:       "a2a2e8826e0a8a23815c811fb034c7c315b0df0a83790887c6d57f6f62df08e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b35ce00d707f0e3f494d1e4708ae37653472874166b3b7d8dec6bd7972085459"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "6.0000000000", shell_output("#{bin}/eva '2 + abs(-4)'").strip
  end
end
