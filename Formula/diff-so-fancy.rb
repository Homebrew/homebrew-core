class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.10.1.tar.gz"
  sha256 "0a3d359c94249f05c3e9654dab4999053a79dcc5090b0390dacf7fbdd2c976af"

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
