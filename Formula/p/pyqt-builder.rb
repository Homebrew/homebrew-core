class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/0b/0a/e7684c054c3b85999354bb3be7ccbd6e6d9b751940cec8ecff5e7a8ea9f7/pyqt_builder-1.18.1.tar.gz"
  sha256 "3f7a3a2715947a293a97530a76fd59f1309fcb8e57a5830f45c79fe7249b3998"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f9c9a7e2ca2bbe7f09634407a93aea1de9ecd5e898656c6157070cebd210d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f9c9a7e2ca2bbe7f09634407a93aea1de9ecd5e898656c6157070cebd210d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f9c9a7e2ca2bbe7f09634407a93aea1de9ecd5e898656c6157070cebd210d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbcd019ff2169a36e038d2991a7c237dbe504c7b68a0ac943e32d2053765754c"
    sha256 cellar: :any_skip_relocation, ventura:       "bbcd019ff2169a36e038d2991a7c237dbe504c7b68a0ac943e32d2053765754c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d76dd4cd42912d127622a98c68edb106af7c530482d1361565a7eebc9307772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d76dd4cd42912d127622a98c68edb106af7c530482d1361565a7eebc9307772"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/e3/11/1ad8d00e08f26eaa45c48c085b8fdb6aba32b5c96e601d96b4b821a5b88e/sip-6.11.0.tar.gz"
    sha256 "237d24ead97a5ef2e8c06521dd94c38626e43702a2984c8a2843d7e67f07e799"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system libexec/"bin/python", "-c", "import pyqtbuild"
  end
end
