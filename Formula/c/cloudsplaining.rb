class Cloudsplaining < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM Security Assessment tool"
  homepage "https://cloudsplaining.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/d1/64/ba28b9b1854a40bcaae318da0e0fe147bd25999e496a8382a5a67c463db1/cloudsplaining-0.8.2.tar.gz"
  sha256 "733085a7648e45714a24e629d05d3dfd592d2925b21fe001c19f55a6d6c1581a"
  license "BSD-3-Clause"
  head "https://github.com/salesforce/cloudsplaining.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b029c54550a9c69b7d18214faad6276c3a717c66e00aaa038288a86b4e6b3693"
    sha256 cellar: :any,                 arm64_sequoia: "66f00293ed3edd39ad132ca5742c804ecd3a702ec77e716d962db936d117bdf3"
    sha256 cellar: :any,                 arm64_sonoma:  "fb0b9ee33848dc1be4541ef3bce0de0449a899ae227e80fc8ead297ec62e9204"
    sha256 cellar: :any,                 sonoma:        "4cdce525a9d48bf240fceb6c904654d8883e7a6165e9e377f1674105b9596430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aa4fe725c6e96f20396dd8f147cb5bb686e643bdc8cfcb6b2afbbc104cd82fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "153a121eb5c89605f357fda4fd5ded4a3454ee91cd6ae82d1ceb50aebc2a913c"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/70/02/d3ee174681961dc2ebfe81f326e1b5e1ba338b7ff939e1e94eef76e7c65a/boto3-1.40.51.tar.gz"
    sha256 "ed1b7750df07b2f2ece0141ff2ed0489db2ec2b5311a956d00a496b05fd4fadb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ca/33/9e197d872adf1eadf8ecc259d0f451143326ff044d236b8971ff8bf980ee/botocore-1.40.51.tar.gz"
    sha256 "a06de20408c3009e59e8f161a1146f1801d279d0923ab950349154900951bb20"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/76/4b/3d870836119dbe9a5e3c9a61af8cc1a8b69d75aea564572e385882d5aefb/cached_property-2.0.1.tar.gz"
    sha256 "484d617105e3ee0e4f1f58725e72a8ef9e93deee462222dbd51cd91230897641"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/ef/ff/d291d66595b30b83d1cb9e314b2c9be7cfc7327d4a0d40a15da2416ea97b/click_option_group-0.5.9.tar.gz"
    sha256 "f94ed2bc4cf69052e0f29592bd1e771a1789bd7bfc482dd0bc482134aff95823"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/8d/37/02347f6d6d8279247a5837082ebc26fc0d5aaeaf75aa013fcbb433c777ab/markdown-3.9.tar.gz"
    sha256 "d2900fe1782bd33bdbbd56859defef70c2e78fc46668f8eb9df3128138f2cb6a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/be/4d/8df5f83256a809c22c4d6792ce8d43bb503be0fb7a8e4da9025754b09658/orjson-3.11.3.tar.gz"
    sha256 "1c0603b1d2ffcd43a411d64797a19556ef76958aef1c182f22dc30860152a98a"
  end

  resource "policy-sentry" do
    url "https://files.pythonhosted.org/packages/2c/62/5ef0720302fff4a3b194c99ee7c6570a7b8086589588f2d5aab352deee35/policy_sentry-0.14.1.tar.gz"
    sha256 "dda37098a5e8038c5d8a0e6b4e644736cd3cfec167b53007604dd92f8a20ea97"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/fb/2e/8da627b65577a8f130fe9dfa88ce94fcb24b1f8b59e0fc763ee61abef8b8/schema-0.7.8.tar.gz"
    sha256 "e86cc08edd6fe6e2522648f4e47e3a31920a76e82cce8937535422e310862ab5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cloudsplaining", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudsplaining --version")

    output = shell_output("#{bin}/cloudsplaining download 2>&1", 1)
    assert_match "botocore.exceptions.NoCredentialsError: Unable to locate credentials", output
  end
end
