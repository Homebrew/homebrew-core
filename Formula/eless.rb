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
    system bin/"eless", "-V"
  end
end
