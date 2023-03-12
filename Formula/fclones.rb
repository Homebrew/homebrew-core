class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "d22eec734dbc7c4b179d650c3e259c6682e923b72e596978adac5cd6f2fccbb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d620949a12704016f1ddc6e61ae760d5a814334243553ed29fe4f5b624a9bd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09e2aa7bfb3b6ff9b096fdd6f45dd199059831703296d88a404934f315d8f217"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8ea10c90f13625c5ac01017f639d0fe18ac69b9198bb64b5b3de8777540d68e"
    sha256 cellar: :any_skip_relocation, ventura:        "9f3a76f3e5923f57d9531e474ed4cf8516a2323b05a56797a90ada5e9c4d863d"
    sha256 cellar: :any_skip_relocation, monterey:       "939f24f8463f53a4fabe0a40722acd47e1cbc46291b33dbb677086eec5aefa90"
    sha256 cellar: :any_skip_relocation, big_sur:        "8959fc5007cbb08aac44486036a27b610f4c0fc265ce58dffeb469f351b666f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38a208281ac10c7c55ceece93b5f01035b4ed25b85cf79ac92bee43aa8fed9f9"
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
