class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.15.1.tar.gz"
  sha256 "b9afd2f80ae1d57991a19832d6979c7080a568d42290a24e59d6a2a82cbc1728"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "586c64302aefc15ab255ddbfb157efdb782a2a7b5f61fa0b00cd5f24df34eb15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab7ecc7b6c25d92fc22a0bf3c22c9362846a0ba742a4b101be898d2b05db9992"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60abe782f2ec06cb3c4e5c3f0ac1ead2926e4f63c7caf595e85054ab273285ad"
    sha256 cellar: :any_skip_relocation, ventura:        "6a92d184dbe72fe95f21b2bd5e1ac8ec2f18575db9b226cd36d036a5b94ad776"
    sha256 cellar: :any_skip_relocation, monterey:       "9df512806c712b253cac5a7e453d4bfc0541e2e3f8f5532dd4a00431704020e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "30ae9bcd50aed962356267fa4d4b74afee7b8274abc1b9058c3c3e49d0fbf94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2ea26badb1a917bc425c656a0847552007de312bc6e6b1799e2628634301cd"
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
