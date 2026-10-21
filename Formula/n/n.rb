class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "44e0bfd66aadff042817d1da90adaf5dfd16d269aefb4f0c79b5a4da23bd0abd"
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
