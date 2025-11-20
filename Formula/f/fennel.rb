class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/refs/tags/1.6.0.tar.gz"
  sha256 "e1f0e457629aedb1e477140667d50297c52913b6cdcf150701795b7717f9ebec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "552c33e11ffe95043577951448cfb2a281100211181140ba6de4bd1360366bda"
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
