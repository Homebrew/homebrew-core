class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "d22eec734dbc7c4b179d650c3e259c6682e923b72e596978adac5cd6f2fccbb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5daa7251fcbc0562c8290353672358499cf380c5372ccb7cf99fc91ae542c493"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a305dc530951fd805edd15776cf102152968563f05d1c9f7ead7180a37cedd64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64362480969c3b7d9a29502da92310d7be6fe48a8563fa1189f047d46d4e7525"
    sha256 cellar: :any_skip_relocation, ventura:        "811e49cb44c7d333b631b254aa1021e569020697529471457ddc7393cb824c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "b0134f7f1c610cc457f6eaf83219016b718c733c764d1332ed7618508bf74c79"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ca886e5be393a60fa6ca69db5ac72582f4c79aa760f2c0bc3f2563d4af75818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02f08377506c1b342b6f593e82fd4fb13c1c8230ab2547fe9805f5b605845d0f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo1.txt").write "foo"
    (testpath/"foo2.txt").write "foo"
    (testpath/"foo3.txt").write "foo"
    (testpath/"bar1.txt").write "bar"
    (testpath/"bar2.txt").write "bar"
    output = shell_output("#{bin}/fclones group #{testpath}")
    assert_match "Redundant: 9 B (9 B) in 3 files", output
    assert_match "2c28c7a023ea186855cfa528bb7e70a9", output
    assert_match "e7c4901ca83ec8cb7e41399ff071aa16", output
  end
end
