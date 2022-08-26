class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "1605c8a5d6677f1d133a8b323b49a7ec0900d62e869d82e2c608a55c40ee0851"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "070d6f16d194ecc745f2ee2fa3161c3f3330edf8563846dd46596da3553b0488"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2e98b6381cbfb12a6223b711a946ccb0ee93ac75a5a841b3294dc4366c65faf"
    sha256 cellar: :any_skip_relocation, monterey:       "113c3e1057b443569c7c3431228097ad6cd6e22d000a30d2a5a2ab58b606e472"
    sha256 cellar: :any_skip_relocation, big_sur:        "5de5088ce85557ba0586e0f4e1a5b44d8628359cd12ebae4a30d0c895b02eef2"
    sha256 cellar: :any_skip_relocation, catalina:       "96404d6f95bfa668778ebd2cacbc62cdacf517e6d0add80af5421d0f456796c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d2741c6bd8407bfa39dbc02d700b95a030df98d6ecf27f8950f95ede84a786"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo1.txt").write "foo"
    (testpath/"foo2.txt").write "foo"
    (testpath/"foo3.txt").write "foo"
    (testpath/"bar1.txt").write "bar"
    (testpath/"bar2.txt").write "bar"
    output = shell_output("fclones group #{testpath}")
    assert_match "Redundant: 9 B (9 B) in 3 files", output
    assert_match "a9707ebb28a5cf556818ea23a0c7282c", output
    assert_match "16aa71f09f39417ecbc83ea81c90c4e7", output
  end
end
