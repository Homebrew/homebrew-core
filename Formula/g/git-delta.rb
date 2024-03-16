class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.17.0.tar.gz"
  sha256 "1abd21587bcc1f2ef0cd342784ce990da9978bc345578e45506419e0952de714"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0bff1b5889c50ca2b54c237e6c5b7c33c3c908ec1cdbacb842733e55a9a45cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c42558c2b0336801757a74159c2e161249024a333392c4da1adf9d73dbfc1a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc82b46b844780c928d44d01416d0866a645bf32121746e36b9ec4e8ac8c1a37"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbf302505500a561df1c54890cc4e0727eb80026363f401450a6e8b355e17b3f"
    sha256 cellar: :any_skip_relocation, ventura:        "33e1208799de874a4ae534e00066520d66d3f58f91e511b41901462af67b359b"
    sha256 cellar: :any_skip_relocation, monterey:       "878fab2a087db804594602e9c773085d8b978ea9bd6d7d129785ea8dd909811b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf0f949bf9a26f26c61136e5d3e544d6eaf1f1ebd0a212dc5fbc737eaabd8b4"
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
