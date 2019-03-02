class MacosUpdate < Formula
  desc "CLI tool for handling macOS software updates"
  homepage "https://github.com/owenlejeune/macOS-update"
  url "https://github.com/owenlejeune/macOS-update/archive/v1.0.tar.gz"
  sha256 "a0329ff4b6db8dd3c15bc42d8898c3d18caa79f697d7326362e807901b05a9c0"

  def install
    bin.install "macosupdate"
  end
end
