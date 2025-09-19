class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/refs/tags/1.5.3.tar.gz"
  sha256 "6fccadb7942dcbebf7325d1427d2ef0c7fa0e9f871b9ef81e48320f193235549"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a9f69e7f99082ff0a9983d90bd11ee3076769ba41c719ce7c21e25bf6548442"
  end

  depends_on "luajit" => [:build, :test]
  depends_on "lua"

  def install
    system "make", "PREFIX=#{prefix}", "install"
    system "make", "LUA=luajit", "PREFIX=#{prefix}", "install"
    share.install "man" if OS.mac? # macOS `make` doesn't install the manpages correctly.
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
    system "lua", "-e", "require 'fennel'"
    system "luajit", "-e", "require 'fennel'"
  end
end
