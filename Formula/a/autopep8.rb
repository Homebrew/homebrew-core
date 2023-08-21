class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/b2/03/49cb49b37a4d51721ece9c628eb9441f9a4e26ee98ad6e5505238d5b2d7a/autopep8-2.0.2.tar.gz"
  sha256 "f9849cdd62108cb739dbcdbfb7fdcc9a30d1b63c4cc3e1c1f893b5360941b61c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9876c8ccc7e08dd15b048a996d0f460b993da7c3d8092c73b08d14412e47a935"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9876c8ccc7e08dd15b048a996d0f460b993da7c3d8092c73b08d14412e47a935"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9876c8ccc7e08dd15b048a996d0f460b993da7c3d8092c73b08d14412e47a935"
    sha256 cellar: :any_skip_relocation, ventura:        "5aba6fbd91b8a69fa0fbf8c23e1b1aba93a7bf0e11a8f3de2f77702f068c6233"
    sha256 cellar: :any_skip_relocation, monterey:       "5aba6fbd91b8a69fa0fbf8c23e1b1aba93a7bf0e11a8f3de2f77702f068c6233"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aba6fbd91b8a69fa0fbf8c23e1b1aba93a7bf0e11a8f3de2f77702f068c6233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd2c70a4d66684833df256b1c1ede1240b09c9c89e434ead620840ed0c3d332f"
  end

  depends_on "python@3.11"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/06/6b/5ca0d12ef7dcf7d20dfa35287d02297f3e0f9e515da5183654c03a9636ce/pycodestyle-2.10.0.tar.gz"
    sha256 "347187bdb476329d98f695c213d7295a846d1152ff4fe9bacb8a9590b8ee7053"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
