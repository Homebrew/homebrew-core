class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/30/8a/dbc2e61f779a60252677f36833d040813f492bb0ca04dfe8aa480c2b39d4/flake8-5.0.3.tar.gz"
  sha256 "b27fd7faa8d90aaae763664a489012292990388e5d3604f383b290caefbbc922"
  license "MIT"
  head "https://gitlab.com/PyCQA/flake8.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9b22b187592e821558d06fc24fab52b37acb40e827f4325b426a3b4618a63d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9b22b187592e821558d06fc24fab52b37acb40e827f4325b426a3b4618a63d7"
    sha256 cellar: :any_skip_relocation, monterey:       "2277958eba4b8be2176850b3529dd7ca9192c19918374cc86f1e4be82bb9be13"
    sha256 cellar: :any_skip_relocation, big_sur:        "2277958eba4b8be2176850b3529dd7ca9192c19918374cc86f1e4be82bb9be13"
    sha256 cellar: :any_skip_relocation, catalina:       "2277958eba4b8be2176850b3529dd7ca9192c19918374cc86f1e4be82bb9be13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1417a4721b4309a7f139e18ed99b23adbf11e82914e2ef2ad4777daf36afcda0"
  end

  depends_on "python@3.10"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/f7/98/95b7936a9439bea0e537a42feca1404e7926518fe054f85d28ad7e4bc6fa/pycodestyle-2.9.0.tar.gz"
    sha256 "beaba44501f89d785be791c9462553f06958a221d166c64e1f107320f839acc2"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/07/92/f0cb5381f752e89a598dd2850941e7f570ac3cb8ea4a344854de486db152/pyflakes-2.5.0.tar.gz"
    sha256 "491feb020dca48ccc562a8c0cbe8df07ee13078df59813b83959cbdada312ea3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~EOS
      print ("Hello World!")
    EOS

    (testpath/"test-good.py").write <<~EOS
      print("Hello World!")
    EOS

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end
