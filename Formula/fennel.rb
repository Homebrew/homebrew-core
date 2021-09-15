class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.10.0.tar.gz"
  sha256 "407d47ae50e9d7a756f47b7bd81c4bdcb0b24c40322b496e7fe7357ae1eee6e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61413fc779425837a7498ece98d85016b3a5d26f1ffb5099f6363afe058b2290"
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
