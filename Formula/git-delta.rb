class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.0.16.tar.gz"
  sha256 "ec1a08e57351673c4ca1aaf618a3ca5d942c3bd775f049a8b1be3e902ec6288d"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30fce1792a9f663a036fc17517ff81dc7da6f6d0849d27f1e341ed402c0799d7" => :catalina
    sha256 "035f3a35e619f7f8b4248b07b9b3edd14df8246d2fbb6c0f8e56522bd9b76a75" => :mojave
    sha256 "12a7db2b8a6fbef2322133e884cf0ec9ab188827f668ca5385529c51780e1707" => :high_sierra
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
