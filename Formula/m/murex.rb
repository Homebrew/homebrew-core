class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v5.0.9310.tar.gz"
  sha256 "4548275096c72171f726bd973952a8e11001b49b7d56470404afeaea46539caf"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25371ab58bc9d435e8e3cc29e333f07fd1ddfd8b8040f739ab2f5a5f2e22dfbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cad4406ad7d724e52d05469713f32e705dc1042fa53c3706c3f9744ccfc9e0d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b7407c497528d2325cbe4b4242048bb9a9c77344f1bfa030b9082b836c4f2ff"
    sha256 cellar: :any_skip_relocation, ventura:        "2fb686054e446a5faf533c21a38b26bfcca810a1e608e27b69b68a3a0c75b414"
    sha256 cellar: :any_skip_relocation, monterey:       "7181e6c72466f408b760eca8150af014d363bc451b3eda844374cf7ed0016ea8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0adc56c8ac16d091204e6ff68728df22236ed390ccfe17a2174033e313bbe20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab6df26088c8bc77241fc562ba3a5106cdc79a35042c2d0564fcfdc7e7bc76d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
