class GitDelta < Formula
  desc "Syntax-highlighting pager for git"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta.git",
    :tag     => "0.0.13",
    :revison => "c2360a90d75e2d574a5d89d3c608ee77748e6d37"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b26d28e691a0937378805d7353f23f4868ebd6d364edaff87e860c8643557d3" => :catalina
    sha256 "3bda33c7d68064463e752b0da28cc5bf682969a63569da815ee12cb16010c36c" => :mojave
    sha256 "e1b30e4dc7d19e7736f25845093c294061b63d884c374d1cacff7a01d37f2705" => :high_sierra
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
