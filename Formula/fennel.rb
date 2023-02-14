class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/1.3.0.tar.gz"
  sha256 "bae4a658b50f6febbaa6183c89208aae4459531fa15e137c0eb8ff98684eb7c3"
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
