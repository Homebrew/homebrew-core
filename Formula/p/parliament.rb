class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/a6/12/92bbf5db0eac6d901ccca51f001b64a4a57f8b06d7189147cd3c9ee570ce/parliament-1.6.4.tar.gz"
  sha256 "ea6b930de2afd2f1591d5624b56b8c9361e746c76ce50a9586cab209054dfa4c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf05669f84a4239aae9ec611ad81bc1bc4d6c325c88822f94e3b547f6e94a868"
    sha256 cellar: :any,                 arm64_sonoma:  "fb00cf494a63ad6c210b0cc52e80d6a34160f7e88f9659a373dd8adde43dd8ff"
    sha256 cellar: :any,                 arm64_ventura: "7a31c5049a383bd602dcb99decde918aeda711922cbdb7e7a41700a977f07963"
    sha256 cellar: :any,                 sonoma:        "670267222577df36ecf9b98e7f20ea5dad3de0c2b6497964135499ee9ff30cb5"
    sha256 cellar: :any,                 ventura:       "ebf99bfb60fd2e7390eab8f0aee76ea11446c2430cd40cd70ef57df684fd8a7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca0b3b8f9be5e3cbff82df3eda432005d51a0516e6af88dd49133f5a1abfdd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbc18a72415b1d0d7d8f516e6832df6eb5acc626139ccf7b861890215b7ddbcf"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/5a/66/a26e7f20039ae3c57524baf26af43216c3959013f23308458f211cce78a5/boto3-1.38.40.tar.gz"
    sha256 "fcef3e08513d276c97d72d5e7ab8f3ce9950170784b9b5cf4fab327cdb577503"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/61/23/42cc861466a34e45bd1783c3b3a547d5f723a8d21f6151cd1e3d84adfba6/botocore-1.38.40.tar.gz"
    sha256 "aefbfe835a7ebe9bbdd88df3999b0f8f484dd025af4ebb3f3387541316ce4349"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "json-cfg" do
    url "https://files.pythonhosted.org/packages/70/d8/34e37fb051be7c3b143bdb3cc5827cb52e60ee1014f4f18a190bb0237759/json-cfg-0.4.2.tar.gz"
    sha256 "d3dd1ab30b16a3bb249b6eb35fcc42198f9656f33127e36a3fadb5e37f50d45b"
  end

  resource "kwonly-args" do
    url "https://files.pythonhosted.org/packages/ee/da/a7ba4f2153a536a895a9d29a222ee0f138d617862f9b982bd4ae33714308/kwonly-args-1.0.10.tar.gz"
    sha256 "59c85e1fa626c0ead5438b64f10b53dda2459e0042ea24258c9dc2115979a598"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/ed/5d/9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191a/s3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}",
    pipe_output("#{bin}/parliament --string '{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}'").strip
  end
end
