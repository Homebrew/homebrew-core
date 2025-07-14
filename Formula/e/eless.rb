class Eless < Formula
  desc "Better `less` using Emacs view-mode and Bash"
  homepage "https://eless.scripter.co/"
  url "https://github.com/kaushalmodi/eless/archive/refs/tags/v0.7.tar.gz"
  sha256 "de7a7891a20a5e7f25c0b5df812edaea87ab0d3336d41821a24e2d248aaf4abc"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "562c9ae16a0fc87aa6752e240e261fa0634f908867f19d716846dceb43ecc72b"
  end

  depends_on "emacs"

  def install
    bin.install "eless"
    info.install "docs/eless.info"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eless -V")
    expected = "This script is not supposed to send output to a pipe"
    assert_equal expected, pipe_output(bin/"eless").chomp
  end
end
