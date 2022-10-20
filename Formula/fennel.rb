class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/1.2.1.tar.gz"
  sha256 "fae8a0b00275529acb3785673b9505f378786ccd2cd2bc16254f6a5fd08e0d19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae18b97efb611231723d835ade911486880d0341eb2cd731ba27516787babe88"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fennel"

    lua = Formula["lua"]
    (share/"lua"/lua.version.major_minor).install "fennel.lua"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
