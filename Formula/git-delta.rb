class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.6.0.tar.gz"
  sha256 "27259c3d305edee5f49a3a992e7d739cab400f478a675b7388fef85a2724217c"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4fd61af38041ab4aa62806f93da19660a1679439b5516ec8a9a8bc527c45878b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e76bbea0a4ce5dbbb90106d9fb5f6aaf67ccac5d7f58e2d1b92390e018525fc4"
    sha256 cellar: :any_skip_relocation, catalina:      "aee11642c678a7d1c0865862b4e8c1834e52818a0cb57f2fec8cb9882f6e0c22"
    sha256 cellar: :any_skip_relocation, mojave:        "13b9a57ef2a7185dec1ca611f02ab94d8d200c0d8a553be82a3f536375e9e76d"
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
