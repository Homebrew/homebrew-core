class Eless < Formula
  desc "Better `less` using Emacs view-mode and Bash"
  homepage "https://eless.scripter.co/"
  url "https://github.com/kaushalmodi/eless/archive/v0.6.tar.gz"
  sha256 "a691a56da6d92f279e46c10d72d3ef6e4951f0e30092ca394622b6e94aae551b"

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
