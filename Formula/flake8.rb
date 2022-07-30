class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/17/cc/76b2e235f985e5fc692402ad74293d6b1b0ffca81574733231aca9b4e682/flake8-5.0.0.tar.gz"
  sha256 "503b06b6795189e55298a70b695b1eb4f6b8d479fae81352fc97c72ca242509e"
  license "MIT"
  head "https://gitlab.com/PyCQA/flake8.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0df982d4a3ed80b694876262243dc7356b3f21bec95e016843964588ea268ef2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0df982d4a3ed80b694876262243dc7356b3f21bec95e016843964588ea268ef2"
    sha256 cellar: :any_skip_relocation, monterey:       "268cb65b355888176c6bbfdfb74547f79ad8faa8b207483bc03766bc33776401"
    sha256 cellar: :any_skip_relocation, big_sur:        "268cb65b355888176c6bbfdfb74547f79ad8faa8b207483bc03766bc33776401"
    sha256 cellar: :any_skip_relocation, catalina:       "268cb65b355888176c6bbfdfb74547f79ad8faa8b207483bc03766bc33776401"
    sha256 cellar: :any_skip_relocation, mojave:         "268cb65b355888176c6bbfdfb74547f79ad8faa8b207483bc03766bc33776401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e1fd8816e95438fa558a91432cdc848760649a020dcc067eb801ee8123e88ff"
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
