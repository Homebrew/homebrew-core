class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/45/f3/24b437da561b6af4840c871fbbda32889ca304fc1f7b6cc3ada8b09f394a/autopep8-1.4.4.tar.gz"
  sha256 "4d8eec30cc81bc5617dbf1218201d770dc35629363547f17577c61683ccfb3ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "e907895a8bb66a4dd3803db9ab36c94ed19d267858d002da0b8cb6a71ced6d79" => :mojave
    sha256 "6906758261366f6cdefebccb7e40418285aa1ab8ced2946f3b865691fad42c26" => :high_sierra
    sha256 "22f0fc75ab33b8096c78c5ad90782d00cbe35c3571d974710d157a30540cfc45" => :sierra
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
