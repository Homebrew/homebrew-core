class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.11.1.tar.gz"
  sha256 "6a9212d3d21af50987604c5930fd9ae899bf59bbcc873185525c81e860a455de"

  bottle :unneeded

  def install
    prefix.install Dir["third_party", "diff-so-fancy"]
    bin.install_symlink prefix/"diff-so-fancy"
  end

  test do
    ENV["TERM"] = "xterm"
    system bin/"diff-so-fancy"
  end
end
