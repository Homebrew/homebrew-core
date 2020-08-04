class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.4.0.tar.gz"
  sha256 "cae9bda3fb1b4e1adea439bb0e834d703d5925f0ace44eafa2d1b1293ae79209"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21a53f197f28899fd2649ed9f685526eb6a4a9fe13819fdc3fa543d5858e04be" => :catalina
    sha256 "db7c9389bf569314917cc0d0e979baf034955fdc90ab77dd4faafb934a71dfca" => :mojave
    sha256 "7aec3f7a0ccd5ce2f7bcd753ba6539fe2b8489e53b6b372a1a7802df036fb47d" => :high_sierra
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
