class Counts < Formula
  desc "Tool for ad hoc profiling"
  homepage "https://github.com/nnethercote/counts"
  url "https://github.com/nnethercote/counts/archive/refs/tags/1.0.6.tar.gz"
  sha256 "4d3394b32afa98b91fd624a9c4df690d07fa1d6559cd87bb82a4bde6131fbc5f"
  license "Unlicense"
  head "https://github.com/nnethercote/counts.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24d9ace69ae8a6c2bdb85fcb5c1c42b53f73209bb2a9958cd02e2b1aaff40fe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "104e0c1a70c346de9a881f3604a940409c21292be6f728bad0d317423d7e3302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "199acdd7193a93a8431adcd011441e85c609dcd6b31060fca9663d623d841ab1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fd0e4ee5182e9000723388e231d8fe2f7ba902e33224c6f1f48bb7e186e3c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5408f15252264a19fabff4a2370e9b222c2c1519f94016d807eacf44831ec13"
    sha256 cellar: :any_skip_relocation, ventura:       "da24a18685e6e26d88c71a4e10dc1639234f798e29c85e118e06728a792a4c4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43508d50d22d1ced7b27695086b8c16a38b217a48aeb999d80e60ad2835d544e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d38003ebf1f3fd5c46e7ce4e87190f617d81a20ac8bc9ff91f8cdb4eddb9374"
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

    assert_match "counts-#{version}", shell_output("#{bin}/counts --version", 1)
  end
end
