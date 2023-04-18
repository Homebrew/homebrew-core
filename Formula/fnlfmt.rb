class Fnlfmt < Formula
  desc "Formatter for Fennel code"
  homepage "https://git.sr.ht/~technomancy/fnlfmt"
  url "https://git.sr.ht/~technomancy/fnlfmt/archive/0.3.0.tar.gz"
  sha256 "8baa2f5ed98f449139f6bd8b4859575c4cfeacc60c0a8884ecaa27bc94e69156"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a733d7bd0372d92ed0f756daf5ce0d816f2a20d49330602047e3dcdc4823b21d"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fnlfmt"
  end

  test do
    (testpath/"testfile.fnl").write("(fn [abc def] nil)")
    expected = "(fn [abc def] nil)\n\n"
    assert_equal expected, shell_output("#{bin}/fnlfmt #{testpath}/testfile.fnl")
  end
end
