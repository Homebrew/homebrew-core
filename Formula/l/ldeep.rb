class Ldeep < Formula
  include Language::Python::Virtualenv

  desc "LDAP enumeration utility"
  homepage "https://github.com/franc-pentest/ldeep"
  url "https://files.pythonhosted.org/packages/7f/9f/121148071d5e825f00120ec589d2e8c21868eb78465850cbfb095118c6e7/ldeep-1.0.72.tar.gz"
  sha256 "4591f267f82c2cebf2150f49f04fe72d062c6bd83f67d6984ea360f3a32a5183"
  license "MIT"
  head "https://github.com/franc-pentest/ldeep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8d00e22a5b7d9038ff4b20b31cc7b8f92f679db6bf06549e446a82445f3a983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f3d11c306402792b706150499ec3a5cdb060e0e1745a4bf2b4c1af84b09669f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "154cc239a047bd4046ba80bd44a45ee7815cc4a3bf63d8e3ba7a303c404e5ca1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcb9d6d26af6f21daba8a79c3697c423825e08c9f25abb05110d38ddcc99c491"
    sha256 cellar: :any_skip_relocation, ventura:       "5d4fa8b5e42dd84e9cf2a799f29bea4e6eaec2cf4785722ee0ca6d1f14335073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "206536ca643fa87021d68af9c51aa7514af22cbc9a9a106abc967acc4c4a307e"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "krb5"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "commandparse" do
    url "https://files.pythonhosted.org/packages/79/6b/6f1879101e405e2a5c7d352b340bc97d1936f8d54a8934ae32aac1828e50/commandparse-1.1.2.tar.gz"
    sha256 "4bd7bdd01b52eaa32316d6149a00b4c3820a40ff2ad62476b46aaae65dbe9faa"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "gssapi" do
    url "https://files.pythonhosted.org/packages/04/2f/fcffb772a00e658f608e657791484e3111a19a722b464e893fef35f35097/gssapi-1.9.0.tar.gz"
    sha256 "f468fac8f3f5fca8f4d1ca19e3cd4d2e10bd91074e7285464b22715d13548afe"
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
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/13/52/13b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6/pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/11/dc/e66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828f/pycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/37/72/88311445fd44c455c7d553e61f95412cf89054308a1aa2434ab835075fc5/termcolor-2.5.0.tar.gz"
    sha256 "998d8d27da6d48442e8e1f016119076b690d962507531df4890fcd2db2ef8a6f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/58/83/6ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5/tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  # support py3.13 build
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/ldeep ldap -d brew.ad -s ldap://127.0.0.1:389 enum_users test 2>&1", 1)
    assert_match "[!] Unable to open connection with ldap://127.0.0.1:389", output
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index c432644..9a5854d 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -19,7 +19,7 @@ dependencies = [
     "termcolor >= 2.3.0, < 3",
     "tqdm >= 4.26.0, < 5",
 ]
-requires-python = ">=3.8.1,<3.13"
+requires-python = ">=3.8.1,<3.14"
 readme = "README.rst"
 keywords = [
     "pentesting security windows active-directory networks",
