class PythonLauncher < Formula
  desc "Launch your Python interpreter the lazy/smart way"
  homepage "https://github.com/brettcannon/python-launcher"
  url "https://github.com/brettcannon/python-launcher/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "31e5a4e50e3db4506e8484db06f6503df1225f482b40a892ffb5131b4ec11a43"
  license "MIT"
  head "https://github.com/brettcannon/python-launcher.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd92ae1827420e02bd899e2a8f4be16b31bad24abb5038f934f944603acf03e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a1439311c007d3300050b0d8783fdae8cff055a1f33505a74c8085c180adeed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5310aafe95f47164c849bbb278708ba5f2a601739c7556e19e9f8389e618320c"
    sha256 cellar: :any_skip_relocation, ventura:        "db1819262548dff7c3f1f55eb4414a5a23f1e23db211eb7cc841d90e11e28ba7"
    sha256 cellar: :any_skip_relocation, monterey:       "2c80376c3923316d00b043281cb9c53a6cfaebc748c16fd0237b7f1dcfd50efe"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccb5a7d8b51f327df0003a9ee2a64bda64c962bdfb86e2b71dc21819c395a74e"
    sha256 cellar: :any_skip_relocation, catalina:       "2f7377330417e885a222ae6e3bcfc51a36415713fce24973eb9448c9be058e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd2b8f79e79ec6ea754393c44e392b57c9ab622568a465b46cdb7e93f85a2b30"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "docs/man-page/py.1"
    fish_completion.install "completions/py.fish"
  end

  test do
    binary = testpath/"python3.6"
    binary.write("Fake Python 3.6 executable")
    with_env("PATH" => testpath) do
      assert_match("3.6 │ #{binary}", shell_output("#{bin}/py --list"))
    end
  end
end
