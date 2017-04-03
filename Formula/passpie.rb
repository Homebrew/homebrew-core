class Passpie < Formula
  include Language::Python::Virtualenv

  desc "Manage login credentials from the terminal"
  homepage "https://github.com/marcwebbie/passpie"
  revision 1
  head "https://github.com/marcwebbie/passpie.git"

  stable do
    url "https://files.pythonhosted.org/packages/14/b9/1ab7e80d03ac286602fbd9c6467e2dfc4e67394470e59622111514f223cd/passpie-1.5.5.tar.gz"
    sha256 "d6d707c54bf338f229b7c82df81cf3a196f52e718b4ec6530bbbe7f4624290af"

    # Remove for > 1.5.5
    # Fixes "Error: Wrong passphrase" when using GPG 2.1.x
    # Reported 25 Mar 2017 https://github.com/marcwebbie/passpie/issues/112
    patch do
      url "https://github.com/marcwebbie/passpie/commit/308ff74.patch"
      sha256 "19feaf07c006ce9f900954d3fda8afc95a2e05e7825076b593bfbed85e16dd03"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "db8c178db7bd254f55e67f0f31502847f86eba86bb80bf2373bb02eb8dada185" => :sierra
    sha256 "7901e797484528b9a1b40fbc304d0dab8e81f562c6904dc2bcb6efc197f8888b" => :el_capitan
    sha256 "7d873719b5e728ba6f75ad343c2bf6dedb781a954ce8ef54561df3bf123dbeb4" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :gpg

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
