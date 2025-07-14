class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/40/8e/a3d17fcdab26b738c6067142461d721c03da8e627944b184bfb28ec8ae3b/pipgrip-0.10.14.tar.gz"
  sha256 "f99791cbe4819f4477237b3487bc8f69258236058f3093c5ccdfd9b157405308"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ddelange/pipgrip.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "134399c082ecebcd84125952bdec73728d7f24cb4640fda90413923b7ed39615"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "134399c082ecebcd84125952bdec73728d7f24cb4640fda90413923b7ed39615"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "134399c082ecebcd84125952bdec73728d7f24cb4640fda90413923b7ed39615"
    sha256 cellar: :any_skip_relocation, sonoma:        "478801aa3624f7d0e77401431e9e6a08c9730c13aa793c81dc790470eafbfadb"
    sha256 cellar: :any_skip_relocation, ventura:       "478801aa3624f7d0e77401431e9e6a08c9730c13aa793c81dc790470eafbfadb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61880555907f5f1f3ca33558af7056e8788b32a6ed3e2ac5f4270805eb8980da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61880555907f5f1f3ca33558af7056e8788b32a6ed3e2ac5f4270805eb8980da"
  end

  depends_on "python@3.13"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/cd/0f/62ca20172d4f87d93cf89665fbaedcd560ac48b465bd1d92bfc7ea6b0a41/click-8.2.0.tar.gz"
    sha256 "f5452aeddd9988eefa20f90f05ab66f17fce1ee2a36907fd30b05bbb5953814d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pip==25.0.1", shell_output("#{bin}/pipgrip --no-cache-dir pip==25.0.1")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip --no-cache-dir dxpy==0.394.0")
  end
end
