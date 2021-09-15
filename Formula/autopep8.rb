class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/77/63/e88f70a614c21c617df0ee3c4752fe7fb66653cba851301d3bcaee4b00ea/autopep8-1.5.7.tar.gz"
  sha256 "276ced7e9e3cb22e5d7c14748384a5cf5d9002257c0ed50c0e075b68011bb6d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e01de60b088330ccdf3c99a1144dd2b2e6470d2916490ffd597e170660e2c702"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e079165ba4d0b9148886ed526d9c8a9be8b637cfd5c74b1ccd52fe87bc6574c"
    sha256 cellar: :any_skip_relocation, catalina:      "5e079165ba4d0b9148886ed526d9c8a9be8b637cfd5c74b1ccd52fe87bc6574c"
    sha256 cellar: :any_skip_relocation, mojave:        "5e079165ba4d0b9148886ed526d9c8a9be8b637cfd5c74b1ccd52fe87bc6574c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9628d932f9697fca789eaa25709a9d8428b0b34fe1336163728dead7287bde49"
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
