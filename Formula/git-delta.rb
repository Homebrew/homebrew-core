class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.15.1.tar.gz"
  sha256 "b9afd2f80ae1d57991a19832d6979c7080a568d42290a24e59d6a2a82cbc1728"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "314576894d97cb599b9e0d7713427e9321d58f956f5e83035b3004437a7b62f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d00daf45a4061198c2b9f2d4f7ff18887af44f5a2f2fd39d8425877d61c6760f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76f858aca5cf74affd1410ea1ec68a51ce3e62f54e9f4de2d5c98e03cf281578"
    sha256 cellar: :any_skip_relocation, ventura:        "a9d543150fc4578a4be0131cdcc12a6ade4c8f573067dfd792f04cc5b62716f8"
    sha256 cellar: :any_skip_relocation, monterey:       "eaab568cb1386840666684aa90c449d847d0b44f5064e3855db35cf738edb4c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaefc855767ffb2e9366f69e1eaea31b606b6e20c590188ca477437fc4c77278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bcc4d16d7c927d94abf8994790d2a0549369a84c0fec9ca27296cb6767a58fe"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    fish_completion.install "etc/completion/completion.fish" => "delta.fish"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
