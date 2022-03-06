class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.12.1.tar.gz"
  sha256 "1b97998841305909638008bd9fa3fca597907cb23830046fd2e610632cdabba3"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a56e38b61f4f78fb03cbf03c746c1d004963ccc11bca42fdb2955b16345a3c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "777c8de36e8bf00b6da3d483bfde2b401aa27bc4897a5cb3af3d827c9547341c"
    sha256 cellar: :any_skip_relocation, monterey:       "f1b2d99f12331d735b1a533fe0aa577f755d281427c3f98b6a2a57935d7c63b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "660fd74bee5c0829e6c4ab337837e49aefd6e8f2b92f03c8d11bd1636d7a284f"
    sha256 cellar: :any_skip_relocation, catalina:       "84b6d2b089325dd6ec92c15b10e7324a004fb7b069f8a02a286da0b3220713c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c515d11fdd950edd2523ae73bec231e9bdfc68458b04f6a525687a8bff20929b"
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
