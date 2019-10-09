class GitDelta < Formula
  desc "Syntax-highlighting pager for git"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta.git",
    :tag     => "0.0.12",
    :revison => "2ba73e32d57075bb8b34181752f977fcbadfe5f5"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f8c588c4f4cfad057029fd9d8848b86bb87fb3cefa4547293e7f8a21cde6601" => :catalina
    sha256 "e65c3f7f684ea10f13f4738af0e9cfde5d35f8600e2d49015e6dea5b2b398389" => :mojave
    sha256 "4404c76204184cdcd89224c86e96b268b7a81979b307f54b57f28338899aadbf" => :high_sierra
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", :because => "both install a `delta` binary"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
