class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.4.4.tar.gz"
  sha256 "4068cb88a4110bbef24b8148e3ae283ff007f4f6aa4780789cda7a412928daa0"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef07bc394646ce496f4df2187a190d9462911309484859eb673a898afe5cd245" => :catalina
    sha256 "766eb46b081280cb6db0e7a18b0af23061de6bc36a17424b9389d044b9f395a9" => :mojave
    sha256 "a21ba72f6937355d553b634caf3498edcd87c3329e134d1ceeaddb6490ba27ea" => :high_sierra
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
