class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7c2c4b427ef280a47cee54544c909c170295d38008871aa0cb6a9aabd7b84d8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96ef579f6aec998a7c0c66d7856600d15e09a9c0f51fc1b4bcd7f9795ecfd756"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7a8ad53a9eb399910e48a317dd4d36b194ead0182c627adace36963300a1340"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49dbba0b474be056c2e99ffed912d54506daf475815731fdc321957ed619a6c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a1d6d82c6be6b8f2ac350072ad287a60907241106d97f60eaab2d1ae777dddb"
    sha256 cellar: :any_skip_relocation, ventura:        "1129520f7ee89ed69e0f1fb203de5ed4ac6a6fd816dfab06cebbadaaad854531"
    sha256 cellar: :any_skip_relocation, monterey:       "5067d8d345006609a70832b6943dcbe5eab606bc43778ad2600c437a1472ddd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f00c0bbc3200595f5100d1675cad4c61a3b9417ba3647690c32959b864ecfd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end
