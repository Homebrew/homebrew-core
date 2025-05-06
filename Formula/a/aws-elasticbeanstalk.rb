class AwsElasticbeanstalk < Formula
  include Language::Python::Virtualenv

  desc "Client for Amazon Elastic Beanstalk web service"
  homepage "https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html"
  url "https://files.pythonhosted.org/packages/6b/8b/b03f194f96b0b80112829a604a69d0dcd16a56fd6ee08c07aa8162db3e72/awsebcli-3.23.3.tar.gz"
  sha256 "9fe174f19882cb345e412feb8916c3202cc07e05766317bf7f4aa3b1f5f0e5cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bff1328c9966afdd7455088015e5f83bb4e3a231e35c8b3bf887425fb7f21e12"
    sha256 cellar: :any,                 arm64_sonoma:  "707f8b6734dcd067d451e26957197fab206f6cc316364d44efe2d37c16164c38"
    sha256 cellar: :any,                 arm64_ventura: "d4dd4143491dd1ca1b0199096bcbbcd96131c4b0f5b244e6e7f3c647e517d8fc"
    sha256 cellar: :any,                 sonoma:        "910c7bf96f41bead6a7a0df1f5adf13f179431a6c76c09825e8b7a90cdbbbc17"
    sha256 cellar: :any,                 ventura:       "09f5966b9a410f9fa0b8dddd030cdd8931cbacb8cf621739063c8b18b5a1bb73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab37c62254f1d8c6b4a49bffaae1ded14cd98b3f9ea75b2d41f773f3573b0a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a36feb727c012195aeead4589036464e60a64b9c9da0c905b6661c2455eaba3"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/0c/5e/3cada2f7514ee2a76bb8168c71f9b65d056840ebb711962e1ec08eeaa7b0/blessed-1.21.0.tar.gz"
    sha256 "ece8bbc4758ab9176452f4e3a719d70088eb5739798cd5582c9e05f2a28337ec"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/44/c7/e290008036749e43f615adada8b7e73bf2405d4b1913de375b5c8f01daa1/botocore-1.38.7.tar.gz"
    sha256 "5c6df7171390437683072aadc0d2dfbcbfa72df52a134a5d4bed811ed214c3df"
  end

  resource "cement" do
    url "https://files.pythonhosted.org/packages/49/a9/94696dcf1483eac1c25f278d79d67c408a170414daa1f7522b96b8afd01d/cement-2.10.14.tar.gz"
    sha256 "342e27db54a6616dd1892ed0bb3597a227cee33dc2d85560426df17fca907058"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/b2/bd26ed086b842b68c8fe9aac380ad7e5118cf84fa7abd45bb059a88368a8/setuptools-80.1.0.tar.gz"
    sha256 "2e308396e1d83de287ada2c2fd6e64286008fe6aca5008e0b6a8cb0e2c86eedd"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/37/72/88311445fd44c455c7d553e61f95412cf89054308a1aa2434ab835075fc5/termcolor-2.5.0.tar.gz"
    sha256 "998d8d27da6d48442e8e1f016119076b690d962507531df4890fcd2db2ef8a6f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/eb init --region=us-east-1 --profile=homebrew-test", 4)
    assert_match("ERROR: InvalidProfileError - The config profile (homebrew-test) could not be found", output)
  end
end
