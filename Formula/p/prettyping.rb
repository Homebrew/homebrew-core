class Prettyping < Formula
  desc "Wrapper to colorize and simplify ping's output"
  homepage "https://denilsonsa.github.io/prettyping/"
  url "https://github.com/denilsonsa/prettyping/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e8484492e3c704b2460a00b0e417a07ad7112b5f4ad9a211931ee031fe64b4b6"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34b060c257cb158f76339e83dc74f498fce30be734f9d007b203f7f95699d5e2"
  end

  def install
    bin.install "prettyping"
  end

  test do
    system bin/"prettyping", "-c", "3", "127.0.0.1"
  end
end
