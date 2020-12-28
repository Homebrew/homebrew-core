class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.4.5.tar.gz"
  sha256 "e19ab2d6a7977a3aa939a2d70b6d007aad8b494a901d47a3e0c2357eedad0c80"
  license "MIT"
  revision 1
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea97c81e666640dad59723fc79e5a7773b064b1cefbb93d2164f2454d2635436" => :big_sur
    sha256 "a2d632b219259aaf9febbf383a0b243a24328a273d859ce320731d017ece8f30" => :catalina
    sha256 "506bc14a8e5e0a371dd1ac5cceaeff6b337d4b84444c6b9809ff4a7c3a588be7" => :mojave
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
