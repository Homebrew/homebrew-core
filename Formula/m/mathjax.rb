class Mathjax < Formula
  desc "JavaScript display engine for LaTeX, MathML, and AsciiMath"
  homepage "https://www.mathjax.org/"
  url "https://github.com/mathjax/MathJax/archive/refs/tags/4.1.3.tar.gz"
  sha256 "f487c39d2913f371eb42dab078559a902da69acca38a9ebec7640a6581535ba3"
  license "Apache-2.0"
  head "https://github.com/mathjax/MathJax-src.git", branch: "master"

  def install
    libexec.install Dir["*"]
    pkgshare.install_symlink libexec/"share/mathjax"
  end

  test do
    assert_path_exists libexec/"node-main.js"
    assert_path_exists libexec/"core.js"
  end
end
