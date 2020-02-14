class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.0.16.tar.gz"
  sha256 "631349484bb52f3bb1c22385e19d98903c094212e83fe109f97aeff0281cf00e"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0248a4a319540d6024cc7875855f99f2dae9b47f13b5c4dcdfdae4f8c66b7d13" => :catalina
    sha256 "32894ad7e77f339198252bc5ebe5e5c0f393a1b9338b4fda3e393b47b74796e7" => :mojave
    sha256 "81d9eb60f8c187c729ccb3bb95a5b8eb0e05e759182bad6253e5f60b53aa52d7" => :high_sierra
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", :because => "both install a `delta` binary"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
