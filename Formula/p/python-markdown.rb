class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/87/2a/62841f4fb1fef5fa015ded48d02401cd95643ca03b6760b29437b62a04a4/Markdown-3.4.4.tar.gz"
  sha256 "225c6123522495d4119a90b3a3ba31a1e87a70369e03f14799ea9c0d7183a3d6"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "953021ba35d051d2a4fc6a76727151c75fc707ae4165619155cd26e8aabf3130"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2118a98603123ff5f283a713c17e3a4588cf577690e6cfbd18cf0f9a86e06f02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6052ea49275af4e1cb22a8defda61803f9dec4157aeb3e118d6c08c6fade88e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b7e1e77dbe6563b35f53dfa1f8140f80d75baf1cb8b807878081a2bf4087a00"
    sha256 cellar: :any_skip_relocation, sonoma:         "937eb61507c316d183c32925ce7bb800defd083bf912989bb060202555fb240d"
    sha256 cellar: :any_skip_relocation, ventura:        "cf1970201addc305f51dd6880da17c12aacd754e1540f2c320dd77d6fc024a03"
    sha256 cellar: :any_skip_relocation, monterey:       "89b7af86db5003d8e9e3ba570476d29d286cdd943fa03911f0a62cc695e939ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "80d58b809875ebe463956a4a5a2eedda9a105e005644d998dd8efc69ff428fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2019874cc73e7e15fa563fc15c0bc187fc91a751e03db65827abbc3db349b1ab"
  end

  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip

    system python3, "-c", "import markdown;"
  end
end
