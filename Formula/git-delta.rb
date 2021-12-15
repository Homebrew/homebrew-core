class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.11.3.tar.gz"
  sha256 "cf68f43d4d26c10551c0137a7e718719958e52267d83f29a8f7794af12095b9e"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ff4746c857dcca439f95969a1635497ee0fc94d0aa4b8752c732270824b7296"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1afc760c011b51015b9ff4e1462a65e9175691d52620811f5d391d030918552"
    sha256 cellar: :any_skip_relocation, monterey:       "76b91c07b5cba89e37a6be69157627a7b884efbf37688c949bffdaaf48227ae8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7567832d48263d7e8ba6bf13739c8718b496484ea207443ac0fa53bfdd0cd1e9"
    sha256 cellar: :any_skip_relocation, catalina:       "f16debd0836eb842214751176f4659090a6fc645f82db2732c299e8b16945f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee876759a709ff17116a611795af0791d0e2cba2e052356fa75262fb38ae9cd3"
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
