class Bd < Formula
  desc "Quickly go back to a parent directory in linux"
  homepage "https://github.com/vigneshwaranr/bd"
  url "https://github.com/vigneshwaranr/bd/archive/v1.02.tar.gz"
  sha256 "66133d21cfa2bffae4ddfc34060635646d7c7e21983e91818e18d7521163bd91"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "bd"
    bash_completion.install "bash_completion.d/bd"
  end

  test do
    assert_match "Version: 1.02", shell_output("bd -v")
  end
end
