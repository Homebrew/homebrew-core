class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "3fbcf08440f25df6b1fd415c5f7fb860ef6c76a3c3d8e72c5bfa73b24f45bf84"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36ef16fa665112518467fd054a8d1e65583bb65b8bf2cb35359210f4bdf76556"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
