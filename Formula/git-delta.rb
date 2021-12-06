class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.11.0.tar.gz"
  sha256 "55e6aa28869247a7fca7aa9229ea2ebeae75e79becb22988e645301778f7388b"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e25e119913f5a76bdb289df4f4e34ac3503b4f7aab890f0ccd4673601b81d231"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "921d3fa2a1820409f39127937a1f273e03b48b2015002ad3aca7719be771ac36"
    sha256 cellar: :any_skip_relocation, monterey:       "99e46ab8d3663523d1fffafe1feaa4057d2acc5b723cfcbcc1fc6bd4fdbf2b58"
    sha256 cellar: :any_skip_relocation, big_sur:        "f139409353c736032d22c8ac039c51e27a4dc4958b94653425470483e8a3f725"
    sha256 cellar: :any_skip_relocation, catalina:       "5a07e9b89a8963bba7e22b2d8b37e6b3c8af23e47ff07d792b08ddd74d382b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41f4fa0baa3d9b2bb9a4ac845f8b483badc79a5a0c7e05a7d4974b39ae1e8697"
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
