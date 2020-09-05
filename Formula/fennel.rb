class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.6.0.tar.gz"
  sha256 "b0d72e46d0a0894cf6d0c95353ed07faadcf3cf815da64eee08c131eed1305d2"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "113e9aa637dd9c8bf2f40b480b5a76f996cfe96954c33f1429b88f8151c48019" => :catalina
    sha256 "113e9aa637dd9c8bf2f40b480b5a76f996cfe96954c33f1429b88f8151c48019" => :mojave
    sha256 "113e9aa637dd9c8bf2f40b480b5a76f996cfe96954c33f1429b88f8151c48019" => :high_sierra
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
