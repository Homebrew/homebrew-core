class Fnlfmt < Formula
  desc "Formatter for Fennel code"
  homepage "https://git.sr.ht/~technomancy/fnlfmt"
  url "https://git.sr.ht/~technomancy/fnlfmt/archive/0.4.0.tar.gz"
  sha256 "b9364b9e69aca6f7b272805a3338b599b1ff706ea881896960ab425f22b0800f"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    manifest_sha256 "cf44138513c6ddbdba4736f012205895faac8a83b8be3d192588a2a0c3ed99ee"
    sha256 cellar: :any_skip_relocation, all: "a7de2d24da3f34f61af506004712abe8eda829b888fe7a565dc1ff931524ce12"
  end

  depends_on "lua"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"testfile.fnl").write("(fn [abc def] nil)")
    expected = "(fn [abc def] nil)\n"
    assert_equal expected, shell_output("#{bin}/fnlfmt #{testpath}/testfile.fnl")
  end
end
