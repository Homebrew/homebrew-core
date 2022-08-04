class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/ad/00/9808c62b2d529cefc69ce4e4a1ea42c0f855effa55817b7327ec5b75e60a/flake8-5.0.4.tar.gz"
  sha256 "6fbe320aad8d6b95cec8b8e47bc933004678dc63095be98528b7bdd2a9f510db"
  license "MIT"
  head "https://gitlab.com/PyCQA/flake8.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d99367e13104e017e51474808e2f681840a8635b564452753aa1d0cab1e9d71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d99367e13104e017e51474808e2f681840a8635b564452753aa1d0cab1e9d71"
    sha256 cellar: :any_skip_relocation, monterey:       "cf33884f5626fef0519263433504107308ecbe5bfd63f508fe5963b1218529f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf33884f5626fef0519263433504107308ecbe5bfd63f508fe5963b1218529f4"
    sha256 cellar: :any_skip_relocation, catalina:       "cf33884f5626fef0519263433504107308ecbe5bfd63f508fe5963b1218529f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b267ac7dd0a7245008dea3b2b996801f3bddd84a5ae4a6159fd7a4deda6af8b"
  end

  depends_on "python@3.10"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/b6/83/5bcaedba1f47200f0665ceb07bcb00e2be123192742ee0edfb66b600e5fd/pycodestyle-2.9.1.tar.gz"
    sha256 "2c9607871d58c76354b697b42f5d57e1ada7d261c261efac224b664affdc5785"
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
