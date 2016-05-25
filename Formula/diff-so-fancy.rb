class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.9.3.tar.gz"
  sha256 "b057683f325874f2473ebfd90583083efc18253cd42fe8d16bcd25bbe426babb"

  bottle :unneeded

  def install
    # temporary fix until upstream uses a directory other
    # than lib for the perl script.
    inreplace "diff-so-fancy", "/lib/", "/libexec/"
    prefix.install "lib" => "libexec"

    prefix.install Dir["third_party", "diff-so-fancy"]
    bin.install_symlink prefix/"diff-so-fancy"
  end

  test do
    ENV["TERM"] = "xterm"
    system bin/"diff-so-fancy"
  end
end
