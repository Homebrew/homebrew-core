class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.5.0.tar.gz"
  sha256 "bdd0696d02c76735aaf6ab3b066660cefd1b2d4a922311d633b02c112218ee50"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9577b157dd309dbc8f975898e24124246043a22e812abf5c8763e88872b2dcf1" => :catalina
    sha256 "9577b157dd309dbc8f975898e24124246043a22e812abf5c8763e88872b2dcf1" => :mojave
    sha256 "9577b157dd309dbc8f975898e24124246043a22e812abf5c8763e88872b2dcf1" => :high_sierra
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
