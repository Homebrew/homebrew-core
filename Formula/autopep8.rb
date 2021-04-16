class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/96/a5/d282540e6e0ea8a3fd58edaf97eff1d787e56787e5bf6c70f670aaedef7a/autopep8-1.5.6.tar.gz"
  sha256 "5454e6e9a3d02aae38f866eec0d9a7de4ab9f93c10a273fb0340f3d6d09f7514"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4b451272fc816df61973e3b9fb6360cb2721d4b433ceac85ede151806220271"
    sha256 cellar: :any_skip_relocation, big_sur:       "90cffde948ca271a3f1a380a0bfb99663e681c5ee839d81a6c0a62ddddb777bd"
    sha256 cellar: :any_skip_relocation, catalina:      "abadae93b663e65e97d316b178352ea9495731130218353f5b9d498671e31bbf"
    sha256 cellar: :any_skip_relocation, mojave:        "d3f976f4106401da5f60fe4251f043c854e15e3aeb08f98a4914f0f5d6c83763"
  end

  depends_on "python@3.9"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/02/b3/c832123f2699892c715fcdfebb1a8fdeffa11bb7b2350e46ecdd76b45a20/pycodestyle-2.7.0.tar.gz"
    sha256 "c389c1d06bf7904078ca03399a4816f974a1d590090fecea0c63ec26ebaf1cef"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
