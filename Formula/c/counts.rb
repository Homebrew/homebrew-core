class Counts < Formula
  desc "Tool for ad hoc profiling"
  homepage "https://github.com/nnethercote/counts"
  url "https://github.com/nnethercote/counts/archive/refs/tags/1.0.3.tar.gz"
  sha256 "1cbe4e5278b8f82d7b6564751e22e96fac36c5b5ee846afd1df47e516342e031"
  license "Unlicense"
  head "https://github.com/nnethercote/counts.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38f55c6b7c4726093d387407511155d010fd2cbaa152b1b982bd8cfd54643a47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66941009740d7b6325920ab2a9e301a6fc06cd48713e202999dd9b021b2829b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "070aab378598e36db9ab4c2699ecb4a572a0235f4ef04c4fb7f19abffc95adeb"
    sha256 cellar: :any_skip_relocation, ventura:        "2d66e4a9002d52c3647195978ecb223dc76634a9e577a8980768d50ea5645b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "89dc49546d6510e8ac7901ae163a68af0ab763a85645dd7efe898c3d5b01cda1"
    sha256 cellar: :any_skip_relocation, big_sur:        "22c64e5c8b35fa8ed743c14e67326177b2823aa116c0416534e96e6aed59c191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23345f07529c12d512021a15737266205a16d176eca74c07c84c39dea4638856"
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
