class Iocextract < Formula
  include Language::Python::Virtualenv

  desc "Defanged indicator of compromise extractor"
  homepage "https://inquest.readthedocs.io/projects/iocextract/en/latest/"
  url "https://files.pythonhosted.org/packages/ad/4b/19934df6cd6a0f6923aabae391a67b630fdd03c12c1226377c99a747a4f1/iocextract-1.16.1.tar.gz"
  sha256 "ec1389a76a5083f643652579610e8313d27ed5821fc57e7b046c23ddec181d44"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/InQuest/iocextract.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e80bc3992418144b704a706a8c34b881c4934d8bc232349fa96588c0f1b8d16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30b675eb4744acf08e55b38c85dcfe209e6a3e64065b3026507b8c2b737892f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c4c886fb0ea6fa0f4365c714a6c09375fdfc73680dc719ed8575182f3628159"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce34bbc744923dce4e6c9462c3dad0ab63b72750b1840c1b21868f48bc647210"
    sha256 cellar: :any_skip_relocation, ventura:        "44b744b1a9be988a88707be7c5de234c6c082ecbc959fa3ff981b9f1ae49f844"
    sha256 cellar: :any_skip_relocation, monterey:       "a12547ae0f9a7254cb677cbb296bdc5f90784ed6d6f85f8dbfdba78797934b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716ec67e46b3f2abff3d97320c8339fc04b5bb3d2898c6bec431b6e2beecdc53"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write <<~EOS
      InQuest customers have had detection for threats delivered from hotfixmsupload[.]com
      since 6/3/2017 and cdnverify[.]net since 2/1/18.
    EOS

    assert_match "hotfixmsupload[.]com\ncdnverify[.]net", shell_output("#{bin}/iocextract -i #{testpath}/test.txt")
  end
end
