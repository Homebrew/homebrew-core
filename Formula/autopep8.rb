class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/d7/33/86a857db9c5081b0e8241568e64c1cb1acc03a869448729fbb6d9822bbee/autopep8-1.4.1.tar.gz"
  sha256 "096426ef4b489784c08395d7fc7f8cbf38a107b806984513e4c2d9070b0dc1d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "b81cbdf875b0cb713b371b5b4b665c5a3300be278defabe5d80c05639620c427" => :mojave
    sha256 "4ab4613f65e899e09a35c6acfb158467a26469a164918abf0cf15ae7e7d806b1" => :high_sierra
    sha256 "822127659150edaf708d23b1175ce82f9c13c4078ea75b687dd17cb2fc38c5db" => :sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
