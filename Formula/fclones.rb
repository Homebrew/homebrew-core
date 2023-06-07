class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "9c006cfd23f09315fb2cfedf6c4204986d39560b30f02f782b531f13b3df82e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81cacc283200c92859bcb8d65de7be438ba5708b45b59920d7ec01bbac673584"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00e1b28d03bdff1eb31630943ff0e0c06a1c8b1ea036e31096ee128a37298708"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8fb695abc91c90337980188a42a2ca18f66da89cc65b8288d65a8faede0fd68"
    sha256 cellar: :any_skip_relocation, ventura:        "cd9743f30e7c6adfaac65b8c71519d841a8de05807ec71a014577b7d11d18557"
    sha256 cellar: :any_skip_relocation, monterey:       "2c9a77f431b962a7dc6b36511b4569ee70a5c9c369156b4d0863d4bbf1dff1a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "29a3285ac8d7fb148871c657114532d8700c4c7099f7a6134e61bb1861a7119f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75a9615691ed18b099d94820864c26c4e3aab57d096e02c249a01fc3cfdb8dd4"
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
