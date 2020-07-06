class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/33/9e/69587808c3f77088c96a99a2a4bd8e4a17e8ddbbc2ab1495b5df4c2cd37e/autopep8-1.5.3.tar.gz"
  sha256 "60fd8c4341bab59963dafd5d2a566e94f547e660b9b396f772afe67d8481dbf0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "79f648b311983b7ce858f88fff0d313502b052b077792db504409a8868181498" => :catalina
    sha256 "4ae421fc461c433ce9dc26c3e9bb1280e468c0a7e2fdcc15abd6c4bcdd5731c1" => :mojave
    sha256 "0c8ee3e0d4202ea2e0a9a438291e7821a22e4046fa5d89a8572adb7823491fc1" => :high_sierra
  end

  depends_on "python@3.8"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/bb/82/0df047a5347d607be504ad5faa255caa7919562962b934f9372b157e8a70/pycodestyle-2.6.0.tar.gz"
    sha256 "c58a7d2815e0e8d7972bf1803331fb0152f867bd89adf8a01dfd55085434192e"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/da/24/84d5c108e818ca294efe7c1ce237b42118643ce58a14d2462b3b2e3800d5/toml-0.10.1.tar.gz"
    sha256 "926b612be1e5ce0634a2ca03470f95169cf16f939018233a670519cb4ac58b0f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
