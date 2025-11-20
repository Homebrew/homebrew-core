class MacosTermSize < Formula
  desc "Get the terminal window size on macOS"
  homepage "https://github.com/sindresorhus/macos-terminal-size"
  url "https://github.com/sindresorhus/macos-terminal-size/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f8e4476549ef4446d979875e87a77365fcfecfe58df7e62a653a402e29c8a0dd"
  license "MIT"
  head "https://github.com/sindresorhus/macos-terminal-size.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "046cbcf0ab73b2a5f6e22b25bf54bbcf305f9a7e8b0af9cb6d60ff773da962ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62b5941a4c8f70dc8ba5564ca015d47a4a6d816932df80672375e3942d097e18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c658e365898186c4566c1786325e2dfb0f37bdc88cf5db7055c828f0d81b2674"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67b30340e06a42f33552b16edc84c355529bbd92758c516587d76bb3571fc23c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f840f609d469c4cda3dc2c100b962116b86a1308543ea69372c72b1d8437d05"
    sha256 cellar: :any_skip_relocation, ventura:       "c322648a0cb287845237865d51194d5d4f45113237c43f90c0048f2d0281932b"
  end

  depends_on :macos

  def install
    # https://github.com/sindresorhus/macos-terminal-size/blob/main/build#L6
    system ENV.cc, "-std=c99", "term-size.c", "-o", "term-size"
    bin.install "term-size"
  end

  test do
    require "pty"
    out, = PTY.spawn(bin/"term-size")
    assert_match(/\d+\s+\d+/, out.read.chomp)
  end
end
