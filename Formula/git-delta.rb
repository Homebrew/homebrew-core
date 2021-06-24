class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.8.0.tar.gz"
  sha256 "706b55667de221b651b0d938dfbb468112b322ed41a634d3ca5c8bd861b19e8a"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "afb3426393648cfc5998016283fa1210bb934f259987cda7fc93d59e233a052b"
    sha256 cellar: :any_skip_relocation, big_sur:       "f1e6bcb87e32084c680daf79cbd497fc1cd24e20004972c07c1f788650548ae1"
    sha256 cellar: :any_skip_relocation, catalina:      "5fcbd1cb8f33bf7e4b2e7e3c7f26dea28e2e37810473ff16779ae5289971f43e"
    sha256 cellar: :any_skip_relocation, mojave:        "8968b402198735d3258dc815e08ec9b6044258ad9f5d5cb133e60efdb8c86f11"
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

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
