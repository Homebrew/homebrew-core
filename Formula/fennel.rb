class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.9.2.tar.gz"
  sha256 "01844552ae1a23b36bea291281f5fb0f1336b9a110caad8810e835ccea53dddc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "677b84572e580da6bda35f79b8fb8ced96356061530653c9d246f2ef15353c1e"
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
