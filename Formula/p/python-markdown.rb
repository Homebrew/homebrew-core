class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/87/2a/62841f4fb1fef5fa015ded48d02401cd95643ca03b6760b29437b62a04a4/Markdown-3.4.4.tar.gz"
  sha256 "225c6123522495d4119a90b3a3ba31a1e87a70369e03f14799ea9c0d7183a3d6"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e47ce3cd5f32d01e63145054e502a7231901b74fd3163f97050192d70427457e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2e789fd1839fc8747f4bfd3f09d82fb322b38de1818890767198f57977dc9aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c06919942f75f4a11144be345117bd9a8232769728425ecc4acec53e182e3c93"
    sha256 cellar: :any_skip_relocation, ventura:        "09a71189f52aed377371795afc3f45071451a96a8553a66291e62b4097c7834e"
    sha256 cellar: :any_skip_relocation, monterey:       "786b7b5b79deca23a668f5746f4c2aeb2ef04fb5944465f1149a10783cc7b6c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "35a65f9f3da4fdcc06ddf07b0cbc0ecf9b6e84e3077f63e52844f94a781fc67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f716c12dd644e01512e9815ccd100070e28e4c8ccee5db92a6d309675e174c"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
