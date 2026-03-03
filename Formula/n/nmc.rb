class Nmc < Formula
  include Language::Python::Virtualenv

  desc "Automatic cleanup of forgotten node_modules directories"
  homepage "https://github.com/hbisneto/NodeModulesCleaner"
  url "https://github.com/hbisneto/NodeModulesCleaner/archive/refs/tags/v1.0.0.1.tar.gz"
  sha256 "89acf5c029f02996f9ccae2ab0b364bb7c664ae4430a94773ff6ab31338d85c7"
  license "MIT"

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/af/2d/7bf41579a8986e348fa033a31cdd0e4121114f6bce2457e8876010b092dd/certifi-2026.2.25.tar.gz"
    sha256 "e887ab5cee78ea814d3472169153c2d12cd43b14bd03329a39a9c6e2e80bfba7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "filesystempro" do
    url "https://files.pythonhosted.org/packages/a3/be/eedcff4f5c2f8f745c4dd0d2beb6564084cf7faab9eec5f1a5894196bb17/filesystempro-3.0.0.0.tar.gz"
    sha256 "9ffc4cf0c6c5192280b8cd8cd1504a85fbb5c0fafd36faa7cfc9207e98b8da49"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"nmc", "--help"
  end
end
