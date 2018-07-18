class Eless < Formula
  desc "Better `less` using Emacs view-mode and Bash"
  homepage "https://eless.scripter.co/"
  url "https://github.com/kaushalmodi/eless/archive/v0.5.tar.gz"
  sha256 "b4da2c7c223996681bb951d50e0d542d8df04baf765c16412fa0848cdb2b3a3d"

  bottle :unneeded

  depends_on "emacs"

  def install
    bin.install "eless"
    info.install "docs/eless.info"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eless -V")
    expected = "This script is not supposed to send output to a pipe"
    assert_equal expected, pipe_output("#{bin}/eless").chomp
  end
end
