class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "9d8bb36076190f799f01470f80e64c6a1f15f0d938793f8f607a2544cdd6115a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e10f85773e6a764bb09a61ee7bcce735fbfcc39fa34616d52c7b68e5812cd0ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927be0b6f1222da4daae5b7a30b18171260b1c98c9d277523d4558359a846629"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2100aa85953e7ae1f36e8b63dc8bf6b4a6d819427baf398d8a829b80af3285dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d4155d6cd85ca0abcfd36e2f9c010d8f598e731eb05b2d3c80a03c4aede7182"
    sha256 cellar: :any_skip_relocation, sonoma:        "92a41e489d01e0e26fd142e765e1c0e25369e5039b5e3947d638da3ed54c4408"
    sha256 cellar: :any_skip_relocation, ventura:       "9952ed3909b1d2c9b840ce2fba135c4dc067094291ff4cfa9f1e9b555c35d0ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61ca95e6eda9e7f1e4805ff143b929bd7e049ca904a18320007020674b66dac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea61b6f1d552320357ffda10b5b9b8d6ebafc9f22bbf4572df706d3d3d742b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "fclones")
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
