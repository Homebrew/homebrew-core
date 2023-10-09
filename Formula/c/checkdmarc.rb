class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https://domainaware.github.io/checkdmarc/"
  url "https://files.pythonhosted.org/packages/4d/db/e74d2576e7ba34bca19b0be491eca684a1b69c2209d278a2be7735b1f0d5/checkdmarc-4.8.4.tar.gz"
  sha256 "c48af28f7dd778f894ad921b4c5650fc60f36549d937c3998df358e56e5801a1"
  license "Apache-2.0"
  revision 1
  head "https://github.com/domainaware/checkdmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8858319e444d36531fbc3a8bce68e434d15eb96ea016d7cb07ee5a8daefedbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3de8bdd48e112b15332b20345362c1141dcf7c58acbedce80fdc2e5b82da42c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4e597452f9a120cd14d16b5a88140335bd6b4324b3902d4657506d0707a3e19"
    sha256 cellar: :any_skip_relocation, sonoma:         "11a23f8476b964b1a8e63630245874110f8718978eccc02a92c16384e6a20105"
    sha256 cellar: :any_skip_relocation, ventura:        "fc04b183f6435b314fc3331cf9968fc761616674b71ef728cb87cd1aec9fe6e3"
    sha256 cellar: :any_skip_relocation, monterey:       "6c2316f23b0db854692b10f4ed72d24965d8744750b5c6cc4ae40b8db674bd44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86678ab032daaf8b71f2729e38cd0d0aa494fa649471ba99f530401280b31696"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "expiringdict" do
    url "https://files.pythonhosted.org/packages/fc/62/c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7/expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/c2/cb/08df2fc61a589996e3dac7d74c25639162a2a8546acf18a738a0f3d11c74/publicsuffixlist-0.10.0.20231002.tar.gz"
    sha256 "a8ef3f5745196fd956bcf6f425b5000450896c616ee6e95130e147e2fae10ccc"
  end

  resource "pyleri" do
    url "https://files.pythonhosted.org/packages/0e/94/fa146d2de46b78237562373a2bb9277d69e4149738a11b69c1f42ca64c33/pyleri-1.4.2.tar.gz"
    sha256 "18b92f631567c3c0dc6a9288aa9abc5706a8c1e0bd48d33fea0401eec02f2e63"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "timeout-decorator" do
    url "https://files.pythonhosted.org/packages/80/f8/0802dd14c58b5d3d72bb9caa4315535f58787a1dc50b81bbbcaaa15451be/timeout-decorator-0.5.0.tar.gz"
    sha256 "6a2f2f58db1c5b24a2cc79de6345760377ad8bdc13813f5265f6c3e63d16b3d7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/checkdmarc -v")

    assert_match "\"base_domain\": \"brew.sh\"", shell_output("#{bin}/checkdmarc brew.sh")
  end
end
