class Counts < Formula
  desc "Tool for ad hoc profiling"
  homepage "https://github.com/nnethercote/counts"
  url "https://github.com/nnethercote/counts/archive/refs/tags/1.0.4.tar.gz"
  sha256 "fe4f869f9cf49a8aae57858e0ed4c76ea5f849db1445a2013d45a8e020b764c0"
  license "Unlicense"
  head "https://github.com/nnethercote/counts.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "82fa9ab01c22a6ee0df0a94c77008b58371646ff586f9298381d4231b06ac090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb7bb551f6987542cace13619dbab2bce843a0c54b0add2090894e7f24b47623"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f743f71875e3dd582631c35c4d4a9d2fb0850f7c170e294898ece405623b902"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ead496d9dd7dd01fc848d4f47465f872d1b942be786773ab6dbab5f05e805b55"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f35bb0445dc8cb22aeb6b08739d76ef4ecf72803d8224b5d1268a4912142a37"
    sha256 cellar: :any_skip_relocation, ventura:        "51668f2ff93d15c246b5a7d57e2aebc235cae290cbde763965fdabc1d1d6c2a0"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ea94d074f19ef53137496307d5887f6590d9542d314b157022c0ca9f68427e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "19aeb112e08fb7e4bac47349d3ad1d5d22338857e929fd8bd9ce122112c7a76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "263fa00c97a3aa55d4857bd1e1ae79d2b1b94f9aafcd7d6f50040cd9bbd7098a"
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
