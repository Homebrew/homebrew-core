class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/refs/tags/1.5.0.tar.gz"
  sha256 "f5ca4a688e9b97d0783b10a834e3563e3d881669c29f89135b5abffce631527a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dada842761c66f316868d09efddd1ea3f9b2d22298842e03aefb7aa26717d1b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dada842761c66f316868d09efddd1ea3f9b2d22298842e03aefb7aa26717d1b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dada842761c66f316868d09efddd1ea3f9b2d22298842e03aefb7aa26717d1b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "dada842761c66f316868d09efddd1ea3f9b2d22298842e03aefb7aa26717d1b1"
    sha256 cellar: :any_skip_relocation, ventura:        "dada842761c66f316868d09efddd1ea3f9b2d22298842e03aefb7aa26717d1b1"
    sha256 cellar: :any_skip_relocation, monterey:       "dada842761c66f316868d09efddd1ea3f9b2d22298842e03aefb7aa26717d1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "505a53bffca2928b7cb49af8f8edbf33267d5e2301ffc1054549b0fa59417cb0"
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
