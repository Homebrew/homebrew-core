class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https://github.com/censys/censys-python"
  url "https://files.pythonhosted.org/packages/31/3f/2094e4c07b5f8142242705b8f7af42550f1b70c9ce457684b834850d40ea/censys-2.2.7.tar.gz"
  sha256 "abec858e5be89c45a60477bd7e51412fee7f55917325b11c3cd970298de3e2bd"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72d90a5b73b735b953bddbc63f43c5815668331e5da7c4ab92b66ca13a2fc2db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa0a1af0c86e534da6abe9d3e833ac7c0ef98cf7983e1335f9bcb9badd547ef8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1288c5f4895aca7fac9aa26a6ed576f4313cab805b7983f6937c189b6f633e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0704197fe7b200c4f195115fd6fac6b16dd17c242ffe7d5702083c7d1224af0b"
    sha256 cellar: :any_skip_relocation, ventura:        "eaf35c6f42e4fc8aa24904834a177be025e337e28a86bb4b7558ae346d5af056"
    sha256 cellar: :any_skip_relocation, monterey:       "3f335cfbb40b493eafff67a16e5a36ddb56c19d46b5c119dcba55de544cfb63d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8072503a695c6414369dd8ec2aadfb88cacf6d94c5e1797c0067ee9f554a162"
  end

  depends_on "pygments"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python@3.11"

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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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
