class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https://domainaware.github.io/checkdmarc/"
  url "https://files.pythonhosted.org/packages/df/06/e61a492a70a2126ac62fea72694aa0ce6f645cbe44ea513d9a68e2df822b/checkdmarc-5.3.1.tar.gz"
  sha256 "1d71e7fa611fa8faa36fad09416b5e2c3265d026d3b5209c051f4e292565e332"
  license "Apache-2.0"
  revision 2
  head "https://github.com/domainaware/checkdmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f37ecbd8f4a67955953854bf1fda6a1bbae3b74e382955eaf9a5626ce5abe7c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07d42320a68588e26252d47a0e3126d8dcdb20f48e8142f9dc48d63865877a99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec5f3ba11b38f7691b7a6b803187a61d4d7f79491e358e4c07711e8ebed05828"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe4460542470e471d17bd37773f70e5afb00cedf8c2cee000552fd4ab56fec3c"
    sha256 cellar: :any_skip_relocation, ventura:        "128d1b85a6a26ba95eb6e5852a581ef0710e82e2cced206bbacb87f770defe08"
    sha256 cellar: :any_skip_relocation, monterey:       "b1734df5655d135bc7fa9b58faed2e461d9361b2747ba2dca9e8420180330c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d8939aaec0fb6e498d45d0d28d815a4945da492c0c6142644ee7231c65e6d6"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "expiringdict" do
    url "https://files.pythonhosted.org/packages/fc/62/c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7/expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/34/be/78f21c540b536e6e0fa3f29b3d996dd2ca6e48a406a8124e9b4c1ac8e717/publicsuffixlist-0.10.0.20240515.tar.gz"
    sha256 "d0195ba9e7d80e3611216bf95208d34489c3d76975c06a7e9e7c09044e6f6d7b"
  end

  resource "pyleri" do
    url "https://files.pythonhosted.org/packages/93/6a/4a2a8a05a4945b253d40654149056ae03b9d5747f3c1c423bb93f1e6d13f/pyleri-1.4.3.tar.gz"
    sha256 "17ac2a2e934bf1d9432689d558e9787960738d64aa789bc3a6760c2823cb67d2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/d8/c1/f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16/requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
  end

  resource "timeout-decorator" do
    url "https://files.pythonhosted.org/packages/80/f8/0802dd14c58b5d3d72bb9caa4315535f58787a1dc50b81bbbcaaa15451be/timeout-decorator-0.5.0.tar.gz"
    sha256 "6a2f2f58db1c5b24a2cc79de6345760377ad8bdc13813f5265f6c3e63d16b3d7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/checkdmarc -v")

    assert_match "\"base_domain\": \"example.com\"", shell_output("#{bin}/checkdmarc example.com")
  end
end
