class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/ec/67/564f7d15712a84d4035aa5ad0b97eeafdeccdb7e806d6a822595bf0ffa5f/autopep8-1.6.0.tar.gz"
  sha256 "44f0932855039d2c15c4510d6df665e4730f2b8582704fa48f9c55bd3e17d979"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4fe99a1999057aebe94c80b0ed5cfd76d48d2e17bdb162dddc1beb9283fe42d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4fe99a1999057aebe94c80b0ed5cfd76d48d2e17bdb162dddc1beb9283fe42d"
    sha256 cellar: :any_skip_relocation, monterey:       "b21a2631ef98d735b04cfbabf9a423d29b4b4dbc437c257a78653d07504513be"
    sha256 cellar: :any_skip_relocation, big_sur:        "b21a2631ef98d735b04cfbabf9a423d29b4b4dbc437c257a78653d07504513be"
    sha256 cellar: :any_skip_relocation, catalina:       "b21a2631ef98d735b04cfbabf9a423d29b4b4dbc437c257a78653d07504513be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59ff19dfd44121e3842ab7bf0bdf19712687d47dd1109e157d232541cb1282b"
  end

  depends_on "python@3.10"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/08/dc/b29daf0a202b03f57c19e7295b60d1d5e1281c45a6f5f573e41830819918/pycodestyle-2.8.0.tar.gz"
    sha256 "eddd5847ef438ea1c7870ca7eb78a9d47ce0cdb4851a5523949f2601d0cbbe7f"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
