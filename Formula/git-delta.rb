class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.9.2.tar.gz"
  sha256 "f002a94119cd5b6fd9deede7f344667358baf5015d0051e055fec6334ee0653f"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb49545db2890d1c9c5ab9f87d95c783ffbfb97ff94ff90f79b77f686a0b5ffb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c968613ffc57497c2dcc0fb1ee5eadfe55138f3a133e4f83d46fae53056ecc9"
    sha256 cellar: :any_skip_relocation, monterey:       "e111b20cd3de86b8f3fefdc38fb550742184a796591fe2f03f92a3b6902d1640"
    sha256 cellar: :any_skip_relocation, big_sur:        "b516a28075ebf70b48277b1d25350d60d70b2a86e5b4163b7ab9c11138e0751c"
    sha256 cellar: :any_skip_relocation, catalina:       "ebb60f2f9e5069a35521381e3fee4951fb5d6cf5ffec915788ed526c2489d213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e8148a98b8fd8f383788d7e63918a99bc2c76a9773edd2a7881d2e30e886d7a"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
