class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https://github.com/censys/censys-python"
  url "https://files.pythonhosted.org/packages/31/3f/2094e4c07b5f8142242705b8f7af42550f1b70c9ce457684b834850d40ea/censys-2.2.7.tar.gz"
  sha256 "abec858e5be89c45a60477bd7e51412fee7f55917325b11c3cd970298de3e2bd"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38e8c30372157890e313a762380ad686d5bb75fa6ee8c4dd1f6835aa9f84c457"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83d0b868c1155c3fa44d231b640551dcd6f05551cc2e5d503e2e01f4b99fd344"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8cde7764f54ce35afc379ba6fde734ced7ba8173b8e033264d1107be8e91b57"
    sha256 cellar: :any_skip_relocation, sonoma:         "d09030bfc8d7ea773375756d502f1872718a06b637dce5dc16eb9676ef0359a7"
    sha256 cellar: :any_skip_relocation, ventura:        "bc8edb18b4aa88176a78f7a47e69201df7d985e7f1758258861e7b37b88d6ca1"
    sha256 cellar: :any_skip_relocation, monterey:       "99c9412e07074a75adc80ace6f26129165d37798995af6057d3fdd6f2c55dcf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3d2bf2b9319e00279880685b2e9e4bc91eb55fa9824b468ba4a63c56294b715"
  end

  depends_on "pygments"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: censys", shell_output("#{bin}/censys --help")
    assert_equal "Censys Python Version: #{version}", shell_output("#{bin}/censys --version").strip
    assert_match "Successfully configured credentials", pipe_output("#{bin}/censys asm config", "test\nn\n", 0)
  end
end
