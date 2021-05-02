class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.9.2.tar.gz"
  sha256 "01844552ae1a23b36bea291281f5fb0f1336b9a110caad8810e835ccea53dddc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf79c94551f3aff22a1a817d1309c3bced68e11fb5053e3c10cec83d78a1e37f"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6f6dcceb6eb8cbd5194a9cbb0a8aa7e945edf567fdbdf300aaff7a64ce31583"
    sha256 cellar: :any_skip_relocation, catalina:      "b82322722a1721123bc711a537d7588a8407112baca4299cc1f21790a1619eed"
    sha256 cellar: :any_skip_relocation, mojave:        "3aec2e7184f24ca615307c1f6cc20c9565ba303f3009ae6c5982891b0fc117c8"
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
