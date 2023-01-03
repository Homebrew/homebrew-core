class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.10.0.tar.gz"
  sha256 "a64fdfc1b1797571a9871746d90ed63d5826eff8aebd6c36ccbc5319ae5265e5"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4983ac71471475516fcf82eca8744586766e9097e3c88564f7293254fd7b9b33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "485f71e137a528385bdce3870aed756d63b8ac547c35a9c115e7bf81a4f5eec6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b265183d1570f0e7a07922bae8a9f8f634aeb73bfc8a6e187a6521393ad80d66"
    sha256 cellar: :any_skip_relocation, ventura:        "ed4173bc3e10ecfac7ea40850e8b99a6161b3538a4db4cd4494176f8915111b1"
    sha256 cellar: :any_skip_relocation, monterey:       "ac37f865e22d2a52994346dee538c37bc5ad2b478fde8bdeb05ada1e1b16ac16"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7d318af843fb20f6262e37101c230e976577fa4d3a34cb15949467e3f6c5d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cb9b2f81ea104b81048c9c736b73204d464a7b0c0fdaae7ccadfb13bdacf086"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
