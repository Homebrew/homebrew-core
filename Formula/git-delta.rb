class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.14.0.tar.gz"
  sha256 "7d1ab2949d00f712ad16c8c7fc4be500d20def9ba70394182720a36d300a967c"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7c16c0cbdf9e6e51d24c877a05c8be4045d2804b0f3e9662055c68b7978caa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59cfd83238180b2b19b87273973af0e9b7260f89f276f97545256088fb7af942"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7a28647fe1d1d4e3a5790910b6fc0f54af11b468cd8bd2ff3a018885886ad4d"
    sha256 cellar: :any_skip_relocation, ventura:        "332091753806ce5f2804c8f55ea5319cd9c1fdb62f70fe068ae17589a1d3ba12"
    sha256 cellar: :any_skip_relocation, monterey:       "5727dfe745c390bfe16ea295e6622b30f283611f33d07f760f5fe63f6304f400"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a2f27f7061835d7f51da6a504f594f55970b3641f534c723fe86ed8043c5819"
    sha256 cellar: :any_skip_relocation, catalina:       "9dc934459be9b1ae71d9c3dd680edc441111561cb241c9ff8b777eec8f869d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86be75a7f0e6ecd53d196fcd5636caa4b438371030783a4cabc550c2ae846cd0"
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
