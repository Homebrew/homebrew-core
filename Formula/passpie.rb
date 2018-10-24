class Passpie < Formula
  include Language::Python::Virtualenv

  desc "Manage login credentials from the terminal"
  homepage "https://github.com/marcwebbie/passpie"
  url "https://files.pythonhosted.org/packages/c8/2e/db84fa9d33c9361024343411875835143dc7b73eb3320b41c4f543b40ad6/passpie-1.6.1.tar.gz"
  sha256 "eec50eabb9f4c9abd9a1d89794f86afe3956e1ba9f6c831d04b164fd4fc0ad02"
  head "https://github.com/marcwebbie/passpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d0bea708df6b337834af0eff5e387a2f134001233171210f854a48b4b53bbbe" => :mojave
    sha256 "864bb80f52775b4941847c929922169fafebce6642ee7301f198e74acd6b0817" => :high_sierra
    sha256 "619b05a27170c7fd8881e1922a7836625175b984ecc1a2cdadb5103bff7a8b58" => :sierra
  end

  depends_on "gnupg"
  depends_on "python"

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "rstr" do
    url "https://files.pythonhosted.org/packages/34/73/bf268029482255aa125f015baab1522a22ad201ea5e324038fb542bc3706/rstr-2.2.4.tar.gz"
    sha256 "64a086a7449a576de7f40327f8cd0a7752efbbb298e65dc68363ee7db0a1c8cf"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/db/40/6ffc855c365769c454591ac30a25e9ea0b3e8c952a1259141f5b9878bd3d/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/6c/2e/0df79439cf5cb3c6acfc9fb87e12d9a0ff45d3c573558079b09c72b64ced/tinydb-3.2.1.zip"
    sha256 "7fc5bfc2439a0b379bd60638b517b52bcbf70220195b3f3245663cb8ad9dbcf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"passpie", "--help"
  end
end
