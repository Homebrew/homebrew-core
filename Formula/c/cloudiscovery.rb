class Cloudiscovery < Formula
  include Language::Python::Virtualenv

  desc "Help you discover resources in the cloud environment"
  homepage "https://github.com/Cloud-Architects/cloudiscovery"
  url "https://files.pythonhosted.org/packages/d3/c2/9a5f93ac5376f83903c8550bde45e2888da3fb092b63e02e19d6c852134c/cloudiscovery-2.4.4.tar.gz"
  sha256 "1170ea352a3c7d5643652ebe96b068482734cd995b9c92dc820206f1b87407e5"
  license "Apache-2.0"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "166757c19b4069447bbb1a41e60be7e734d61f845cb0f951fe7410a099a87e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "064a3e7e97a886909f4fb368dcebef7707e3f8ecce081af90e096c01792fd6d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bf4aff37f693f03a1c5487cb10091b711d2da575107da81db51d5cafdce814b"
    sha256 cellar: :any_skip_relocation, sonoma:        "078273ecd102d192d38ded37f8f768467b592302c8b58b7b0d9e5097ee41e158"
    sha256 cellar: :any_skip_relocation, ventura:       "3e3e859e0ad0cfcf0ce7fa5a0063304194345ecb6c47c03c560b35fddb02c41c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3895cb0a39abcd9fdf74f527894fbe09dad23464b0356884abee1ff81f146ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d88b7b392ea5615d256ec973cd48d482570d6a8b6d3fc2f703a72443c042fa3"
  end

  deprecate! date: "2024-10-11", because: :unmaintained

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/2f/3b/f421b30e32c33ce63f0de3b32ea12954039a4595c693db4ea4900babe742/boto3-1.38.41.tar.gz"
    sha256 "c6710fc533c8e1f5d1f025c74ffe1222c3659094cd51c076ec50c201a54c8f22"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/98/46/cb33f5a0b00086a97c4eebbc4e0211fe85d66d45e53a9545b33805f25b31/botocore-1.38.41.tar.gz"
    sha256 "98e3fed636ebb519320c4b2d078db6fa6099b052b4bb9b5c66632a5a7fe72507"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/8a/89/817ad5d0411f136c484d535952aef74af9b25e0d99e90cdffbe121e6d628/cachetools-6.1.0.tar.gz"
    sha256 "b4c4f404392848db3ce7aac34950d17be4d864da4b8b66911008e430bc544587"
  end

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "diagrams" do
    url "https://files.pythonhosted.org/packages/0c/50/abb3442117b933ae08c948b4c08672eba5f78a35ef820c03f5979affbe3b/diagrams-0.24.4.tar.gz"
    sha256 "367b3056bc8875b5a32dcf66c7aad961cb83527b8f345dced82f17ee82781f72"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/83/5a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9f/graphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/a2/88/d193a27416618628a5eea64e3223acd800b40749a96ffb322a9b55a49ed1/identify-2.6.12.tar.gz"
    sha256 "d8de45749f1efb108badef65ee8386f0f7bb19a7f26185f74de6367bffbaf0e6"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/43/16/fc88b08840de0e0a72a2f9d8c6bae36be573e475a6326ae854bcc549fc45/nodeenv-1.9.1.tar.gz"
    sha256 "6ec12890a2dab7946721edbfbcd91f3319c6ccc9aec47be7c7e6b7011ee6645f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pre-commit" do
    url "https://files.pythonhosted.org/packages/08/39/679ca9b26c7bb2999ff122d50faa301e49af82ca9c066ec061cfbc0c6784/pre_commit-4.2.0.tar.gz"
    sha256 "601283b9757afd87d40c4c4a9b2b5de9637a8ea02eaff7adc2d0fb4e04841146"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/ed/5d/9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191a/s3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/56/2c/444f465fb2c65f40c3a104fd0c495184c4f2336d65baf398e3c75d72ea94/virtualenv-20.31.2.tar.gz"
    sha256 "e10c0a9d02835e592521be48b332b6caee6887f332c111aa79a09b9e79efc2af"
  end

  # drop setuptools dep, upstream pr ref, https://github.com/Cloud-Architects/cloudiscovery/pull/192
  patch do
    url "https://github.com/Cloud-Architects/cloudiscovery/commit/905c1dc15812000dc7ed2beb9d5193bd6bbe6131.patch?full_index=1"
    sha256 "7a75658504faa46ad9c5424a836d7a1df25e56b64bec88d57ccddf7c06025d5d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{aws-vpc,aws-iot,aws-policy,aws-all,aws-limit,aws-security}",
      shell_output(bin/"cloudiscovery --help 2>&1")

    assert_match "Neither region parameter nor region config were passed",
      shell_output(bin/"cloudiscovery aws-vpc --vpc-id vpc-123 2>&1")
  end
end
