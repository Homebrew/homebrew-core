class GitDelta < Formula
  desc "Syntax-highlighting pager for git"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.0.14.tar.gz"
  sha256 "777b90bb20c89b63eb158d238dfb38914c3bc4617d65f8a0e465227f9c6884f9"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a9ee6648bba008253f5258a755824d7654160c216cc415f1e0bcf24337e5d936" => :catalina
    sha256 "cdbc6610c601419514a7dadaff05c47601ea5c1704aec54e6cceb00467b2a195" => :mojave
    sha256 "b486d9c5f1115d350ae265edc9e87de91135703a55a7c9263c314958ab0b5cac" => :high_sierra
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
