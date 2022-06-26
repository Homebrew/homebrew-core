class CyralGimmeDbToken < Formula
  include Language::Python::Virtualenv

  desc "Eases using Cyral for SSO login to databases"
  homepage "https://cyral.com/docs/connect/repo-connect/#cli-token-retriever-for-sso"
  url "https://files.pythonhosted.org/packages/3d/c8/506ef49b36301dbd335e18f4ba720983bfbb430ebe136f9807f6408e5062/cyral-gimme-db-token-0.8.0.tar.gz"
  sha256 "6b8e907fcceb92601d26f74d613a2e8176a9a36e150727d4866631744434f2f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3c9d33ce975f531f505480e6c5b5a32f1acbc9106a4068d0d449e2cfb03bd808"
    sha256 cellar: :any,                 arm64_big_sur:  "7dbdd977fc29ba7b4446f463e7ba9dbca774b8dc81719e9724ee8ee9049475e8"
    sha256 cellar: :any,                 monterey:       "75ccf3d4b95ee01adc95f505871fcef2694dc0bcbaf495b83f7a222dcf7ebe76"
    sha256 cellar: :any,                 big_sur:        "414a3a5270900f5e0b1431dda180c3de1ff6eaea4b3e042ce98d0468842de75e"
    sha256 cellar: :any,                 catalina:       "6f98513a49a9f48ff1eb9486321fd3ee7f0f72e7783ab58216d8c0b38401d773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d07cc33a68870bc798a08a87109d8f537a0bbe464df8fe26932c645ba8f8d2a3"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/1e/44/372fd82a5dd5800f3dc53d04bcc95e0702fad4039c3b7fa2fa8ee18b902d/awscli-1.22.58.tar.gz"
    sha256 "567a5861f0101dabb05a5658e7aa1abb6c66e8a5a1a22360b8a7e17d2282cf4c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/36/ae/e2a16367140d66a5b45df2f831da20dcb2cb8824e0e334554294647a2ac0/botocore-1.24.3.tar.gz"
    sha256 "979e5c5e826ff115f4903fe9887b191f3809229f694a747f910e1221fe63efc7"
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
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/66/e2/cc19f36aade1ef40cba69555fcf713d942ec9e31ecff2415948bd885911d/s3transfer-0.5.1.tar.gz"
    sha256 "69d264d3e760e569b78aaa0f22c97e955891cd22e32b10c51f784eeda4d9d10a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  def install
    # setuptools>=60 prefers its own bundled distutils, which is incompatabile with docutils~=0.15
    # Force the previous behavior of using distutils from the stdlib
    # Remove when fixed upstream: https://github.com/aws/aws-cli/pull/6011
    with_env(SETUPTOOLS_USE_DISTUTILS: "stdlib") do
      virtualenv_install_with_resources
    end
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/gimme_db_token --version")
    assert_match "Please continue the authentication in the opened browser window",
      shell_output("#{bin}/gimme_db_token --address localhost --timeout 1")
    assert_match "Error: Invalid value", shell_output("#{bin}/gimme_db_token unsupported 2>&1", 2)
  end
end
