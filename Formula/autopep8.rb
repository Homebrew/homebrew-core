class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/cf/30/9efc988f92f41e2ba51211e3d317ee82260d563ae84dceb53f7021a1bdfe/autopep8-1.4.tar.gz"
  sha256 "655e3ee8b4545be6cfed18985f581ee9ecc74a232550ee46e9797b6fbf4f336d"
  revision 1

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
