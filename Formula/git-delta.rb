class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.12.1.tar.gz"
  sha256 "1b97998841305909638008bd9fa3fca597907cb23830046fd2e610632cdabba3"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1beb3e5f5cad3ae50c907db60bf964e854ab131731a51c833761f6d87b471c55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "455a725e8983e86b71fea8784212b8521e45061a3732a33f7605627123bf6c19"
    sha256 cellar: :any_skip_relocation, monterey:       "cb5f9b5e650fbfd361bbc527761bb8197e825f81231758ec7657be54fbf095b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "34aa86f417729f4a5775a67523e118b8822f3e8cda5dbe4015c9a8cf6b58c97b"
    sha256 cellar: :any_skip_relocation, catalina:       "8da8f6149943fdc40560af3a60c94f271b6ce7e24f2686047272c1f3cffe7d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34e306990fe7d02412d2587b9fcae73fd6552e49f9adf4dd75fee3e15be07090"
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
