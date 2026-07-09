class Counts < Formula
  desc "Tool for ad hoc profiling"
  homepage "https://github.com/nnethercote/counts"
  url "https://github.com/nnethercote/counts/archive/refs/tags/1.0.7.tar.gz"
  sha256 "a5685538819838ba2fba0b78d11b5d80e37753b9015735f71f0c2065442fe9d8"
  license "Unlicense"
  head "https://github.com/nnethercote/counts.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2f17f2b9f8199aa0177f07115e7880d933b06e2e5348acfd63284855d45fb64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68b6b379ab3d791ab5ebe45fa8173e2689a36d7b3ba12abd0c8aeb3eef4f5686"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c330e6758722d04159249a940bd3e429878fe48d7f66c1c126e54045369416"
    sha256 cellar: :any_skip_relocation, sonoma:        "cffc66f3ebcdc02e5f656baeb5beac4b369f1655682c92f53c3b926b861590e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb49e94d8a7f1e13e84c74b9c5d97d342477d09a2f65ffaa6b21b54b8ca191dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25e29cb5ccf375beff6f7d302eeec0873e537c187f6f84aa2442e8841d88f9c1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.txt").write <<~EOS
      a 1
      b 2
      c 3
      d 4
      d 4
      c 3
      c 3
      d 4
      b 2
      d 4
    EOS

    output = shell_output("#{bin}/counts test.txt")
    expected = <<~EOS
      10 counts
      (  1)        4 (40.0%, 40.0%): d 4
      (  2)        3 (30.0%, 70.0%): c 3
      (  3)        2 (20.0%, 90.0%): b 2
      (  4)        1 (10.0%,100.0%): a 1
    EOS

    assert_equal expected, output

    assert_match "counts-#{version}", shell_output("#{bin}/counts --version")
  end
end
