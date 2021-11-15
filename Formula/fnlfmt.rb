class Fnlfmt < Formula
  desc "Formatter for Fennel code"
  homepage "https://git.sr.ht/~technomancy/fnlfmt"
  url "https://git.sr.ht/~technomancy/fnlfmt/archive/0.2.2.tar.gz"
  sha256 "9e14d6750495c78daa7a474ff2d44bccee260e3d39e55dd61d86986e75bd9def"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18b456dcb6cc242942c5677c9b8ab8e74274426f5eba01038819dd5b71f9db79"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fnlfmt"
  end

  test do
    (testpath/"testfile.fnl").write("(fn [abc def] nil)")
    expected = "(fn [abc def]\n  nil)\n\n"
    assert_equal expected, shell_output("#{bin}/fnlfmt #{testpath}/testfile.fnl")
  end
end
