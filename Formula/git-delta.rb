class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.1.1.tar.gz"
  sha256 "50519e97310b54ddb485635ac8e0984670d4ae64fc7fd4a5ed2b67cc6b77347f"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b652f9da416c0cbaae4b796ce967f271c578b970fbd83d226a3a7b9452047de2" => :catalina
    sha256 "e8403154aa7014a39cfb92dfa9855994a10e3e16f1b69bf4e55f739947b153f2" => :mojave
    sha256 "8462225c46a7b4ed8c6061a10324978f8fb3319c400cbfec4854afe88795d82f" => :high_sierra
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", :because => "both install a `delta` binary"

  def install
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
