class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.8.3.tar.gz"
  sha256 "cf48d52d20a12e11a3a6afd436a75550e78fc39c358e85a75caa08b39e4e75c6"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c1863678cb96ffb95451fc4677cea5ef2fb2280d61efe7061884e21fddc0c4f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "784f02aca241d3055f7932a4ebdc983955dbfa1551cf96b99a67c67da382e9e5"
    sha256 cellar: :any_skip_relocation, catalina:      "50954d3cc47cdf353f050ca12f378779e827f724c41a48e40b3d4b6a7ebb53d6"
    sha256 cellar: :any_skip_relocation, mojave:        "45420b913807614d341c14e715253be518ac9b77ebaa947af2b32528c3ed0382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b20c3983f9578a40a3644fa9b6078bf4cc77c63e18ac80ef2c751104b5f91c5"
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
