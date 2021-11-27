class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.10.2.tar.gz"
  sha256 "e0f71d72eca543478941401bd96fefc5fa3f70e7860a9f858f63bfecf8fd77a5"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "958ecd0b59319ca35ce70dc736f7ecbe34476ee5f1ec8673969c72eeb2f4f05e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86b28450d70b4b2c3adb3a00b21ae15fa8f99518438ffbeff34e615473c4dd5f"
    sha256 cellar: :any_skip_relocation, monterey:       "1c55af69105d26b266836ad212c4c679535a3c805a2f9186f2055cd9056e0572"
    sha256 cellar: :any_skip_relocation, big_sur:        "28971e92bde7325b51b03de2c3cef88d1e6fc344f6661715d89e4fcf76fe641c"
    sha256 cellar: :any_skip_relocation, catalina:       "750028fba1d4e8492273625b4d852eb83c70a63d2d397ee666e96f2b84ec43e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75173f6772025d54685234cfff062a3e552c1bd613a472f48d7287c62dbb9e73"
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
