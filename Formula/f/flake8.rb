class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/9b/af/fbfe3c4b5a657d79e5c47a2827a362f9e1b763336a52f926126aa6dc7123/flake8-7.3.0.tar.gz"
  sha256 "fe044858146b9fc69b551a4b490d69cf960fcb78ad1edcb84e7fbb1b4a8e3872"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "267809e6dbc558aa736d35ab4888565edfeb5ce2b745d5df46ffa527990435e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "267809e6dbc558aa736d35ab4888565edfeb5ce2b745d5df46ffa527990435e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "267809e6dbc558aa736d35ab4888565edfeb5ce2b745d5df46ffa527990435e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5d9c63f6473d3e0d349d8ef6dd6c291f22c116863c2851274ff10c73d88030a"
    sha256 cellar: :any_skip_relocation, ventura:       "c5d9c63f6473d3e0d349d8ef6dd6c291f22c116863c2851274ff10c73d88030a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "267809e6dbc558aa736d35ab4888565edfeb5ce2b745d5df46ffa527990435e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "267809e6dbc558aa736d35ab4888565edfeb5ce2b745d5df46ffa527990435e6"
  end

  depends_on "python@3.13"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/11/e0/abfd2a0d2efe47670df87f3e3a0e2edda42f055053c85361f19c0e2c1ca8/pycodestyle-2.14.0.tar.gz"
    sha256 "c4b5b517d278089ff9d0abdec919cd97262a3367449ea1c8b49b91529167b783"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/45/dc/fd034dc20b4b264b3d015808458391acbf9df40b1e54750ef175d39180b1/pyflakes-3.4.0.tar.gz"
    sha256 "b24f96fafb7d2ab0ec5075b7350b3d2d2218eab42003821c06344973d3ea2f58"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~PYTHON
      print ("Hello World!")
    PYTHON

    (testpath/"test-good.py").write <<~PYTHON
      print("Hello World!")
    PYTHON

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end
