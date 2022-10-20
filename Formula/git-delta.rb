class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.14.0.tar.gz"
  sha256 "7d1ab2949d00f712ad16c8c7fc4be500d20def9ba70394182720a36d300a967c"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10d123a9f5e0870ca59aa41722e7b9b9ccf7981628edf136be5fdbcaf15828a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edde3e7ae68861141ad9dddfe1657df3f3169360e4e599a9bfdf84c01a4d62e5"
    sha256 cellar: :any_skip_relocation, monterey:       "0c063b6baada08b163814a6247c0d47f8259bb9af095b122731ffc5fb2b83434"
    sha256 cellar: :any_skip_relocation, big_sur:        "0614ce7a6f55cd03c3d058c3ebea3b2863d53a0ba7438b5686161056bdcf8050"
    sha256 cellar: :any_skip_relocation, catalina:       "6e78fd1a992dfd9a0069384d76db81bb906e1bb7c45256a71190f7487222dcec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f82a93765d4d7878c6fa6503a5b16a1123f0b12fb5fed03e21a1aa98cb48f56"
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
