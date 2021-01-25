class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.8.0.tar.gz"
  sha256 "436b8f09d3fd732aca668f0344d449b04cc9aa28d3ac15db702ee3a9fbe66d31"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d24cc6598a9a43c5f3f67bcccad569dec640b905b327d8878fa6119986dd5ac" => :big_sur
    sha256 "56c0321e0cf404639fb0132f3e82f6b532d4b68d3fc2b1957902044a0f43cb2f" => :arm64_big_sur
    sha256 "f0479ade4c88dfab5a805ee7caa02da8c9a17b15ea86461073f453307ba729db" => :catalina
    sha256 "4d84f7288018a332b867d032da898368cdbb3a17527b09b82efe2f1adffabc1c" => :mojave
  end

  depends_on "lua"

  def install
    system "make", "fennel"
    bin.install "fennel"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
