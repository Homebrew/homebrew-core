class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.9.0.tar.gz"
  sha256 "31e9001621581e52a0a445902d9c35e2efc7570481570e26039d5f2ef665bd46"

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
