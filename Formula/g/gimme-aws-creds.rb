class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/40/d1/b233b4cb1f867062d42e4eacc0f6a828bb466f05717c11b7db50c68dc4f5/gimme-aws-creds-2.8.0.tar.gz"
  sha256 "eb53777d2f4b05040c47ed89feed8380c7722c00c04fa6057dd14c041d032b5b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10e9aa13207535f3f2d9e8a00572f6ec7f4ea4c8f8295c074d6e52911b9def89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "551c6741a062df8510b1b236b0ad236c527c540d3719dfd83e1529ecb6ffe3b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45b4ac07092bf8843e09e2144e66e38309cf611b20ebe1f53917f00c06e948b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "02c5d14ab2640f8194223048bdec39c6fe5935c55e92b7ad17f69d74766f83c2"
    sha256 cellar: :any_skip_relocation, ventura:        "596a8b466c9f3f21fd10701102881bdb5f240846864a55f3b50aa7faf9469726"
    sha256 cellar: :any_skip_relocation, monterey:       "e0f169d48b0a8de2b7458e2d52a98f57311be18f183e02c6057f14e3825b4eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3b67e5b2339a61dfd506b0bc23aaec995219c0d770ab2f6d8d884d6eccc612"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  # Extra package resources are set for platform-specific dependencies in
  # pypi_formula_mappings.json, since the output of `bump-formula-pr` and
  # `update-python-resources` is impacted by whether command is run on macOS
  # or Linux. Remove if Homebrew logic is enhanced to handle this. Also,
  # occasionally check if any of these Python dependencies are no longer used.
  #
  # macOS: `pyobjc-framework-localauthentication`, ...
  # - gimme-aws-creds
  #   ├── ctap-keyring-device
  #       └── pyobjc-framework-localauthentication
  #           ├── pyobjc-core
  #           ├── ...

  resource "aenum" do
    url "https://files.pythonhosted.org/packages/63/6c/a71e18de7c651f384b328be6bccadbbd472aca62f547c1a307b9388d03ca/aenum-3.1.11.tar.gz"
    sha256 "aed2c273547ae72a0d5ee869719c02a643da16bf507c80958faadc7e038e3f73"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/18/93/1f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258b/aiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/03/27/f00f10c9dd957e38a45201d06abd45e830ad14511972b8f934e49bd5a20c/boto3-1.34.73.tar.gz"
    sha256 "f45503333286c03fb692a3ce497b6fdb4e88c51c98a3b8ff05071d7f56571448"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/96/7a/dd229e7fc5f281963637a202cad1d7235d94d05786520ebc1ad0700f0d56/botocore-1.34.73.tar.gz"
    sha256 "8df020b6682b9f1e9ee7b0554d5d0c14b7b23e3de070c85bcdf07fb20bfe4e2b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "ctap-keyring-device" do
    url "https://files.pythonhosted.org/packages/c4/c5/5c4ce510d457679c8886229ddbdc2a84969d63e50fe9fb09d6975d8e500e/ctap-keyring-device-1.0.6.tar.gz"
    sha256 "a44264bb3d30c4ab763e4a3098b136602f873d86b666210d2bb1405b5e0473f6"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/74/6e/58e1bb40a284291ab483d00831c5b91fe14d498a3ae7c658f3c588658e4b/fido2-0.9.3.tar.gz"
    sha256 "b45e89a6109cfcb7f1bb513776aa2d6408e95c4822f83a253918b944083466ec"
  end

  resource "flatdict" do
    url "https://files.pythonhosted.org/packages/3e/0d/424de6e5612f1399ff69bf86500d6a62ff0a4843979701ae97f120c7f1fe/flatdict-4.0.1.tar.gz"
    sha256 "cd32f08fd31ed21eb09ebc76f06b6bd12046a24f77beb1fd0281917e47f26742"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/cf/3d/2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085/frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "furl" do
    url "https://files.pythonhosted.org/packages/2a/0a/31a43d63d25f045b88fe7d3267e9ec3ce3820572205a9342c1cdf2ad2ca3/furl-2.1.3.tar.gz"
    sha256 "5a6188fe2666c484a12159c18be97a1977a71d632ef5bb867ef15f54af39cc4e"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/a5/8a/ed955184b2ef9c1eef3aa800557051c7354e5f40a9efc9a46e38c3e6d237/jaraco.classes-3.3.1.tar.gz"
    sha256 "cb28a5ebda8bc47d8c8015307d93163464f9f2b91ab4006e09ff0ce07e8bfb30"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/7c/b4/fa71f82b83ebeed95fe45ce587d6cba85b7c09ef3d9f61602f92f45e90db/jaraco.context-4.3.0.tar.gz"
    sha256 "4dad2404540b936a20acedec53355bdaea223acb88fd329fa6de9261c941566e"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/57/7c/fe770e264913f9a49ddb9387cca2757b8d7d26f06735c1bfbb018912afce/jaraco.functools-4.0.0.tar.gz"
    sha256 "c279cb24c93d694ef7270f970d499cab4d3813f4e08273f95398651a634f0925"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/93/c3/6fafc393844ef43b36a5d908495ee49dd7e67f3568d4ae848a696daaf713/keyring-25.0.0.tar.gz"
    sha256 "fc024ed53c7ea090e30723e6bd82f58a39dc25d9a6797d866203ecd0ee6306cb"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/ad/7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4/more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/f9/79/722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836/multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/b1/fc/f366482050517fb34ec60a02ed02e0fd985aa66920a6dda4f30431cdf498/okta-2.9.5.tar.gz"
    sha256 "a8c70ed134db30f8dcfabd883a5c09a9b6923b3b5ab7d3266161f8920cbdbf00"
  end

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/53/4e/3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789f/orderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/4a/a3/d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0d/pyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/31/a4/b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1/pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/c1/e2/3af0b7213dd338e62da339c1c99605a8e3658a31f260040f9851ce144c71/pydash-8.0.0.tar.gz"
    sha256 "5a90d98b5f370bb9620f786221579df8f83d54f1f58de6a66f52b1bdba7175d1"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/24/ac/61c58e65780c6ba0523997d236fac99e38e5ddfabfd5b500409f8239a257/pyobjc-core-10.2.tar.gz"
    sha256 "0153206e15d0e0d7abd53ee8a7fbaf5606602a032e177a028fc8589516a8771c"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/b0/c0/7eb30628e1a60c8b700f0b15280417c754eda9f186d05d47f4cac6f4e1a7/pyobjc-framework-Cocoa-10.2.tar.gz"
    sha256 "6383141379636b13855dca1b39c032752862b829f93a49d7ddb35046abfdc035"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https://files.pythonhosted.org/packages/ae/dd/15f5d505f097e655824d8d88d93f67d0bbb40a3c589c1e2f9eff71683344/pyobjc-framework-LocalAuthentication-10.2.tar.gz"
    sha256 "26e899e8b4a90632958eb323abbc06d7b55c64d894d4530a9cc92d49dc115a7e"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/8f/3c/f251e7143a44b62f4e87f0cb7b42d30c8dbef1be0de4db45a4bdcfb4ac71/pyobjc-framework-Security-10.2.tar.gz"
    sha256 "20ec8ebb41506037d54b40606590b90f66a89adceeddd9a40674b0c7ea7c8c82"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-jose" do
    url "https://files.pythonhosted.org/packages/e4/19/b2c86504116dc5f0635d29f802da858404d77d930a25633d2e86a64a35b3/python-jose-3.3.0.tar.gz"
    sha256 "55779b5e6ad599c6336191246e95eb2293a9ddebd555f796a65f838f07e5d78a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/e0/ad/bedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28/yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| r.name.start_with?("pyobjc") && OS.linux? }
    venv.pip_install_and_link buildpath
  end

  test do
    # Workaround gimme-aws-creds bug which runs action-configure twice when config file is missing.
    config_file = Pathname(".okta_aws_login_config")
    touch(config_file)

    assert_match "Okta Configuration Profile Name",
      pipe_output("#{bin}/gimme-aws-creds --profile TESTPROFILE --action-configure 2>&1",
                  "https://something.oktapreview.com\n\n\n\n\n\n\n\n\n\n\n")
    assert_match "", config_file.read

    assert_match version.to_s, shell_output("#{bin}/gimme-aws-creds --version")
  end
end
