class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.9.1.tar.gz"
  sha256 "a4d0c274ca7d7a07a988302b6ba568073592b9475833319a6f207ce892c14c9b"

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
