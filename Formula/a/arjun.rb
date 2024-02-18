class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/83/2d/e521035e38c81c9d7f4aa02a287dddeb163ad51ebca28bef7563fc503c07/arjun-2.2.2.tar.gz"
  sha256 "3b2235144e91466b14474ab0cad1bcff6fb1313edb943a690c64ed0ff995cc46"
  license "AGPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b9c6ae5dc31783c0fbda6b937d6438bbb2520f26ef33b329fa5d2198890a84c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aabcaba6f266aae16dfbed6a81c92d14dba64f003ce01cbf4df149b1a6cc4c2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9588702cd88a65074928a25a79d383fa30eeeb1c55ffb5d19cd3339e537de703"
    sha256 cellar: :any_skip_relocation, sonoma:         "4aab5ee06302fc9b31c076220da9295fd2d1fafadb5b353de5ae3ec95cfcf22a"
    sha256 cellar: :any_skip_relocation, ventura:        "2ac401acee3285219dcd6c44e6ba4a3978a16629bc1d433946a2bd180e5cd360"
    sha256 cellar: :any_skip_relocation, monterey:       "0c8ad8435fa83f7676abcd1b53d7eb20ac118a00395d1fe70e27b76330e25a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1c3c0ec336701591f52733e81c1ba4ac404975a649d2103f8bdc0baa1f543f"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/ee/c9/3132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5/dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET")
    assert_match "No parameters were discovered", output
  end
end
