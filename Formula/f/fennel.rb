class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/refs/tags/1.5.1.tar.gz"
  sha256 "7456737a2e0fc17717ea2d80083cfcf04524abaa69b1eb79bded86b257398cd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c76f783953158324a8398d7a2cb95bebfdfdeb3991f134fd013ef47febc27a26"
  end

  depends_on "luajit" => [:build, :test]
  depends_on "lua"

  def install
    system "make", "PREFIX=#{prefix}", "install"
    system "make", "LUA=luajit", "PREFIX=#{prefix}", "install"
    share.install "man"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
    system "lua", "-e", "require 'fennel'"
    system "luajit", "-e", "require 'fennel'"
  end
end
