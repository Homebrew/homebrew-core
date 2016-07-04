class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.10.0.tar.gz"
  sha256 "3ebaa9a82fb87299ea90afb757a9e854a4c49fad8856950cc26ddb06b86464e9"

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
