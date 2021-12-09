class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/6e/95/74209c24ac099c109109229bee14886c210edefb3f6bd73096e3a2277a93/awscurl-0.26.tar.gz"
  sha256 "5cb14aa948160e8fda1e1285ab4824ee0f54b0af87f9bd169ee49fab0c09cb6c"
  license "MIT"
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c766f40b782e20ab1f6b431b0061cf67cd27780184eeb0f9fb7b8333c4f8293f"
    sha256 cellar: :any,                 arm64_big_sur:  "5db7d043fa495d89a02e532df8d6ab6ffc4ab53907c6afd71cbe9d5f98ae896f"
    sha256 cellar: :any,                 monterey:       "4d76541fa100f58d7cf9d67b411f95494f822b2aae1472deab20f05c029f6ec3"
    sha256 cellar: :any,                 big_sur:        "87227d9721d1ceb8d30f735fee431c152769d490c740f03ef6cfcd44253306e1"
    sha256 cellar: :any,                 catalina:       "735b681b8c7b614ce3685f08b6309bd6fab171abecb0be7eec38421190878e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc92fe305ec2e0963c6f64453769a8ff5688964aa21af2e0d3f3d9cca9fb28b"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/68/e4/e014e7360fc6d1ccc507fe0b563b4646d00e0d4f9beec4975026dd15850b/charset-normalizer-2.0.9.tar.gz"
    sha256 "b0b883e8e874edfdece9c28f314e3dd5badf067342e42fb162203335ae61aa2c"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/02/a8/5fae273a45a3e4e34ea560c99a4843fe2d9fc6fb691de064dc9c72c46e57/configparser-5.2.0.tar.gz"
    sha256 "1b35798fdf1713f1c3139016cfcbc461f09edbf099d1fb658d4b7479fcaa3daa"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/60/06/d9109aba62c0b42466195e5b9b30dded26621a675b73998218070d8cc637/cryptography-36.0.0.tar.gz"
    sha256 "52f769ecb4ef39865719aedc67b4b7eae167bafa48dbc2a26dd36fa56460507f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/54/9a/2a43c5dbf4507f86f7c43cba4195d5e25a81c988fd7b0ea779dfc9c6973f/pyOpenSSL-21.0.0.tar.gz"
    sha256 "5e2d8c5e46d0d865ae933bef5230090bdaf5506281e9eec60fa250ee80600cb3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Curl", shell_output("#{bin}/awscurl --help")

    assert_match "No access key is available",
      shell_output("#{bin}/awscurl --service s3 https://homebrew-test-none-existant-bucket.s3.amazonaws.com 2>&1", 1)
  end
end
