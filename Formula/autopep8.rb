class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/cf/30/9efc988f92f41e2ba51211e3d317ee82260d563ae84dceb53f7021a1bdfe/autopep8-1.4.tar.gz"
  sha256 "655e3ee8b4545be6cfed18985f581ee9ecc74a232550ee46e9797b6fbf4f336d"

  bottle do
    cellar :any_skip_relocation
    sha256 "9204b7d2219335c683348f48d80d42cd16164e0ef6c5a7d23d1fa380dc855df2" => :mojave
    sha256 "51bfe07d678044f8a691aa9bf76b1e382fd11cfb3524d1fca11ba1213d9bdd00" => :high_sierra
    sha256 "3e2992962feb4e81888895d626a35264c85cde6b0a10a831451802b25279d5c2" => :sierra
    sha256 "198b90c7c3911dd6ca76c1a49940cf33afc585d307a45e1c41c1254ed19f94dc" => :el_capitan
  end

  depends_on "python@2"

  def install
    venv = virtualenv_create(libexec)
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
