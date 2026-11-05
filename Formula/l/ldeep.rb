class Ldeep < Formula
  include Language::Python::Virtualenv

  desc "LDAP enumeration utility"
  homepage "https://github.com/franc-pentest/ldeep"
  url "https://files.pythonhosted.org/packages/dc/ce/fc8e0894c94229434d324fbbb128f77d05fb2b8a8ac59bd64cfc6da4fa7f/ldeep-2.0.4.tar.gz"
  sha256 "02164e530e27792249fbea496dfa8d312000f7d7bf9935a457e24e79983cb63f"
  license "MIT"
  head "https://github.com/franc-pentest/ldeep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7595632fb1c25cd068f2900c08b2165533c8671655b23b8205c2ee904475c30b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1019cb59a3b033c012276dc574563c9fd4c67c49f537fd75220519b117c48ba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19dd32a3c9484a4d95fb519e6460b81059f89c135ff5c8971c3d3a07f48b3410"
    sha256 cellar: :any,                 arm64_linux:       "aa63f8529e0424df24bdb827f69ac4cf8db1219a6a413ffc6b9a5d52f30e01ab"
    sha256 cellar: :any,                 x86_64_linux:      "8bbbde0c567d9ed28871c1c77eda7587b8fc6c9cb91652277b7e0dac018fcbd0"
  end

  depends_on "rust" => :build # for `dnspython`
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.15"

  uses_from_macos "krb5"

  pypi_packages exclude_packages: "cryptography"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "commandparse" do
    url "https://files.pythonhosted.org/packages/79/6b/6f1879101e405e2a5c7d352b340bc97d1936f8d54a8934ae32aac1828e50/commandparse-1.1.2.tar.gz"
    sha256 "4bd7bdd01b52eaa32316d6149a00b4c3820a40ff2ad62476b46aaae65dbe9faa"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
  end

  resource "gssapi" do
    url "https://files.pythonhosted.org/packages/6b/fb/9492eb37b5786369b7e96fff2cf4040713acb33b96124813e058cbbd4356/gssapi-1.12.0.tar.gz"
    sha256 "0b48f17296f869db89221c3bde463fdff35152a4cb99ae4aaa42b0b64333fc6c"
  end

  resource "ldap3-bleeding-edge" do
    url "https://files.pythonhosted.org/packages/b6/72/1f50f58d90ebc3900159db6b313f600b08460300543dab20f4087aa81eee/ldap3_bleeding_edge-2.10.1.1337.tar.gz"
    sha256 "8f887372ac0e38da25e98a98f4b773f58a618cf99a705a15caa5273075b56999"
  end

  resource "oscrypto" do
    url "https://files.pythonhosted.org/packages/06/81/a7654e654a4b30eda06ef9ad8c1b45d1534bfd10b5c045d0c0f6b16fecd2/oscrypto-1.3.0.tar.gz"
    sha256 "6f5fef59cb5b3708321db7cca56aed8ad7e662853351e7991fcf60ec606d47a4"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/88/7e/3c0da41061a2021cac7cd524fd57092adbe5b515e8bf9005702e366802e2/pyasn1-0.6.5.tar.gz"
    sha256 "6b11616a6bcf3a40e635f082bb232fa57b5e0dd7f517bd7ddd69ec3794508a47"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/a9/75/b8a9ba9a15b1b190d1fb21e75e921934c9bcd7e63e137f96b56ed274328c/pycryptodome-3.24.1.tar.gz"
    sha256 "3f9e74444c0ecbec7af232a95d282c74b114d53212ce075ed17b7fd7dca32bb3"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f4/e7/50e72301e32acb73a314e663c2014e1ddefc019d5f434ff14ec89861d664/pycryptodomex-3.24.1.tar.gz"
    sha256 "09081666ffc599976c0b8b29caf2cf82212c0f05bed233c8f8ed53e4f6e1d356"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/46/79/cf31d7a93a8fdc6aa0fbb665be84426a8c5a557d9240b6239e9e11e35fc5/termcolor-3.3.0.tar.gz"
    sha256 "348871ca648ec6a9a983a13ab626c0acce02f515b9e1983332b17af7979521c5"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  def install
    inreplace "pyproject.toml", 'requires-python = ">=3.9,<3.15"', 'requires-python = ">=3.9"'
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/ldeep ldap -d brew.ad -s ldap://127.0.0.1:389 enum_users test 2>&1", 1)
    assert_match "[!] Unable to open connection with ldap://127.0.0.1:389", output
  end
end
