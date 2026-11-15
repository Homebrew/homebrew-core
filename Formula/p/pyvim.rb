class Pyvim < Formula
  include Language::Python::Virtualenv

  desc "Pure Python Vim clone"
  homepage "https://github.com/prompt-toolkit/pyvim"
  url "https://files.pythonhosted.org/packages/c3/31/04e144ec3a3a0303e3ef1ef9c6c1ec8a3b5ba9e88b98d21442d9152783c1/pyvim-3.0.3.tar.gz"
  sha256 "2a3506690f73a79dd02cdc45f872d3edf20a214d4c3666d12459e2ce5b644baa"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "256e18589710ad7ed0448f0bc0eb03670d7aa4cfad723af2538c96ca45db6c25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "599048dc5e4be6430fe595f912c32e2970db218522dcc985dc69de041c52a3b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "617114c69fe69b9fa0ebf68bb5a03424eb7cb9bc446223d8d91f98ea916abd80"
    sha256 cellar: :any,                 arm64_linux:       "8d9d355b9c701e002f27975eef712c148db7b905ac07f730c29a6ff13931fce6"
    sha256 cellar: :any,                 x86_64_linux:      "bbe78217bd124726a8d1a099718b2b3352337192ae5fd035285422f8c9f84820"
  end

  depends_on "python@3.15"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/2c/1b/3ba8bd62723cfe1b651c4e4b89b33767fce7a08bb800491cf1d3dd3a7716/pyflakes-4.0.3.tar.gz"
    sha256 "94762a3a5a343a79b28754f96c554bce057a592a4896907d73f0369fe824e053"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Vim clone", shell_output("#{bin}/pyvim --help")
  end
end
