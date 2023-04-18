class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/1.3.0.tar.gz"
  sha256 "bae4a658b50f6febbaa6183c89208aae4459531fa15e137c0eb8ff98684eb7c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "469c84e00a749285ff97e81321d8c7d3cfcbf94ba2049de6556283363047f92d"
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
