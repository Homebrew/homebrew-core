class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/refs/tags/1.4.2.tar.gz"
  sha256 "b44a205ee7ebdee22f83d2a7a87742172295b8086b5361850dfab4f49699e44f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8af6684c2a65280d090441f5dd9b323d566bef0f07d2bfd2a508729ee639c42c"
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
