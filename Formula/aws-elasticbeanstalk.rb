class AwsElasticbeanstalk < Formula
  include Language::Python::Virtualenv

  desc "Client for Amazon Elastic Beanstalk web service"
  homepage "https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html"
  url "https://files.pythonhosted.org/packages/d2/1a/564eab628edbe1815d2bfde14a1cfb9a3e0e14a7a217731792ec60e1e80f/awsebcli-3.20.7.tar.gz"
  sha256 "8672d6a9ce14cd49efcf8c26299f0970459430f9a1d817504b5200cb10bec9be"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f02743fdae224c62bd0fbac829d883533b72ab6b704bdaf9da856cfb9646dfd4"
    sha256 cellar: :any,                 arm64_monterey: "e0dc66ae824179060cb91e5c9ce7510650814c9f4d0c1b8c38fa6e257a621335"
    sha256 cellar: :any,                 arm64_big_sur:  "f69efeae043592519f71ab4e9f90f6772a2f976312c169f222eea17382bc1f22"
    sha256 cellar: :any,                 ventura:        "9d23430365633218e9b6adddde9a4a1aad7c9d75a02619d22958a1cac27e53e3"
    sha256 cellar: :any,                 monterey:       "d85ef5335c836a77685b55176b5ed4fb3639d2e19a96b4002576a5506c1ed395"
    sha256 cellar: :any,                 big_sur:        "cf8405cbea0e06c270b13cd100b1f0bd09e43c1668278bdb1e1e046c5e317d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae9c3f13a5e64c51e90251ba76c576591cffdc29794834618e015e318eecbdb5"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libffi"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/86/04/c78cabb6c84e7abe6d83f253cdc4c98d5c17fec4a8d07ae4dc73bdcd2b5d/botocore-1.29.158.tar.gz"
    sha256 "2fd3b625f3d683d9dd6b400aba54d54a1e9b960b84ed07a466d25d1366e59482"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "cement" do
    url "https://files.pythonhosted.org/packages/70/60/608f0b8975f4ee7deaaaa7052210d095e0b96e7cd3becdeede9bd13674a1/cement-2.8.2.tar.gz"
    sha256 "8765ed052c061d74e4d0189addc33d268de544ca219b259d797741f725e422d2"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/93/b7/b6b3420a2f027c1067f712eb3aea8653f8ca7490f183f9917879c447139b/cryptography-41.0.2.tar.gz"
    sha256 "7d230bf856164de164ecb615ccc14c7fc6de6906ddd5b491f3af90d3514c925c"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/fd/46/6f6116c30cb859a0cdb95444140e9fe0be0de455c9c83748ee421aec8274/docker-4.4.4.tar.gz"
    sha256 "d3393c878f575d3a9ca3b94471a3c89a6d960b35feb92f033c0de36cc9d934db"
  end

  resource "docker-compose" do
    url "https://files.pythonhosted.org/packages/0a/43/e71f087c308f7d7566449212ecaf3e02323e6dd0f5b9b6b0fb64cbfd4df6/docker-compose-1.25.5.tar.gz"
    sha256 "7a2eb6d8173fdf408e505e6f7d497ac0b777388719542be9e49a0efd477a50c6"

    # Build patch for cython 3+
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/99732fa/aws-elasticbeanstalk/docker-compose-pyyaml6.patch"
      sha256 "5382d20b105a20fc6a30a0ac2cedbff290afb0eb769ef4824c3ec6ee54fd8015"
    end
  end

  resource "dockerpty" do
    url "https://files.pythonhosted.org/packages/8d/ee/e9ecce4c32204a6738e0a5d5883d3413794d7498fe8b06f44becc028d3ba/dockerpty-0.4.1.tar.gz"
    sha256 "69a9d69d573a0daa31bcd1c0774eeed5c15c295fe719c61aca550ed1393156ce"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/87/62/cee9551811c846e9735f749dbdf05d4f9f0dbcecd66eae35b5daacf9a117/paramiko-3.2.0.tar.gz"
    sha256 "93cdce625a8a1dc12204439d45033f3261bdb2c201648cfcdc06f9fd0f94ec29"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/24/9f/a9ae1e6efa11992dba2c4727d94602bd2f6ee5f0dedc29ee2d5d572c20f7/pathspec-0.10.1.tar.gz"
    sha256 "7ace6161b621d31e7902eb6b5ae148d12cfd23f4a249b9ffb6b9fee12084323d"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/d4/52/3be868c7ed1f408cb822bc92ce17ffe4e97d11c42caafce0589f05844dd0/semantic_version-2.8.5.tar.gz"
    sha256 "d2cb2de0558762934679b9a104e82eca7af448c9f4974d1f3eeccff651df8a54"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/e4/84/4686ee611bb020038375c5f11fe7b6b3bb94ee78614a1faba45effe51591/texttable-1.6.7.tar.gz"
    sha256 "290348fb67f7746931bcdfd55ac7584ecd4e5b0846ab164333f0794b121760f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/48/bf/c706b56243f1641159ff211b51d3341024e1cdf63defc2b74595b6319039/websocket-client-0.59.0.tar.gz"
    sha256 "d376bd60eace9d437ab6d7ee16f4ab4e821c9dae591e1b783c58ebd8aaf80c5c"
  end

  # patch to work with pyyaml6, remove when merged and released
  # pyyaml6 patch PR, https://github.com/aws/aws-elastic-beanstalk-cli/pull/442
  # also update six constraint, upstream PR ref, https://github.com/aws/aws-elastic-beanstalk-cli/pull/447
  patch :DATA

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/eb init --region=us-east-1 --profile=homebrew-test", 4)
    assert_match("ERROR: InvalidProfileError - The config profile (homebrew-test) could not be found", output)
  end
end

__END__
diff --git a/requirements.txt b/requirements.txt
index 421afcf..84b11de 100644
--- a/requirements.txt
+++ b/requirements.txt
@@ -6,8 +6,8 @@ python-dateutil>=2.1,<3.0.0 # use the same range that 'botocore' uses
 requests>=2.31
 setuptools >= 20.0
 semantic_version == 2.8.5
-six>=1.11.0,<1.15.0
+six>=1.11.0,<1.17.0
 termcolor == 1.1.0
 wcwidth>=0.1.7,<0.2.0
-PyYAML>=5.3.1,<5.5 # use the same range that 'aws-cli' uses. This is also compatible with 'docker-compose'
+PyYAML>=5.3.1,<6.1 # use the same range that 'aws-cli' uses. This is also compatible with 'docker-compose'
 urllib3>=1.26.5 #1.26.5 fix CVE-2021-33503
