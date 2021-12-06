class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.11.1.tar.gz"
  sha256 "e3617e02a06cfe5b414da5f14c28f15293bd736ec14ddd0a25ce477666fe9a75"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69a030b56efa1679b7b9c21063e370b7a46fd4f5348b396bf248b437a8e6ce44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acac01619ebdc09ccff8f649465a44ae4d6461d69a21740876c6db4caf32fce2"
    sha256 cellar: :any_skip_relocation, monterey:       "0fcb640ef5e4cf52308cb273aa46ef7f512d92a1fa38a828f571156a1330b3af"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d1005fba37e04a4dd143a49d4e4c3347eb06d401d86f192be2b36d793b69566"
    sha256 cellar: :any_skip_relocation, catalina:       "17bade640fb5519cc4ee24d15014bc53d64e7134206024df22b6b2b49b94a6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73391a98a05e13a1344f0c2e314eba45aa4e0c7833f5316bcece6719beb881e5"
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
