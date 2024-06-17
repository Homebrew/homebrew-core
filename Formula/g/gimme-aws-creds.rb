class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/63/73/9e508d37d4d301f6a3811fdc0b0a076696de87f82ad8a81ec28c3e6befb5/gimme_aws_creds-2.8.2.tar.gz"
  sha256 "12784f4b749617d7391bf2056373990277858dc9886328832b545e9e334f24d3"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "691cd52ef35210bdf42bae37b220752876163f23bef2d1a1d3618b08ce3fd9cb"
    sha256 cellar: :any,                 arm64_ventura:  "b36acd114c1436cd2842a3458364a668bd78fa465a5625844bcca3498c719689"
    sha256 cellar: :any,                 arm64_monterey: "a643b1064d661d12d2bf61ea8958f4d6caaccb27a4b28005d3ab9ef125212d24"
    sha256 cellar: :any,                 sonoma:         "124d1f4fe2be1798331fb6ff063354bd30d5f645af669de49a22aeaeed0cec2b"
    sha256 cellar: :any,                 ventura:        "b6403b810612147711bdadccb090eb8f76382b295cf328c09e20219685c7756c"
    sha256 cellar: :any,                 monterey:       "81e5bb4e43dafd0283e1a64d68404fd12ddec2d78d1b1083afa84f4598798e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d776abd5288cb3bf6c2720ead5643ad39054e2102038c777241837c764b97eda"
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
    url "https://files.pythonhosted.org/packages/04/a4/e3679773ea7eb5b37a2c998e25b017cc5349edf6ba2739d1f32855cfb11b/aiohttp-3.9.5.tar.gz"
    sha256 "edea7d15772ceeb29db4aff55e482d4bcfb6ae160ce144f2682de02f6d693551"
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
    url "https://files.pythonhosted.org/packages/ee/b4/8fc1043365aa5bf1056426acda0b15b38551b669eaec5ed3cd019c6b4c8b/boto3-1.34.114.tar.gz"
    sha256 "eeb11bca9b19d12baf93436fb8a16b8b824f1f7e8b9bcc722607e862c46b1b08"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4c/7c/0a169bb7389625b97c95daed070e807a6e89580f013ba422a65a635d11c1/botocore-1.34.114.tar.gz"
    sha256 "5705f74fda009656a218ffaf4afd81228359160f2ab806ab8222d07e9da3a73b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "ctap-keyring-device" do
    url "https://files.pythonhosted.org/packages/c4/c5/5c4ce510d457679c8886229ddbdc2a84969d63e50fe9fb09d6975d8e500e/ctap-keyring-device-1.0.6.tar.gz"
    sha256 "a44264bb3d30c4ab763e4a3098b136602f873d86b666210d2bb1405b5e0473f6"
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
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/c9/60/e83781b07f9a66d1d102a0459e5028f3a7816fdd0894cba90bee2bbbda14/jaraco.context-5.3.0.tar.gz"
    sha256 "c2f67165ce1f9be20f32f650f25d8edfc1646a8aeee48ae06fb35f90763576d2"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/bc/66/746091bed45b3683d1026cb13b8b7719e11ccc9857b18d29177a18838dc9/jaraco_functools-4.0.1.tar.gz"
    sha256 "d33fa765374c0611b52f8b3a795f8900869aa88c84769d4d1746cd68fb28c3e8"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jwcrypto" do
    url "https://files.pythonhosted.org/packages/e1/db/870e5d5fb311b0bcf049630b5ba3abca2d339fd5e13ba175b4c13b456d08/jwcrypto-1.5.6.tar.gz"
    sha256 "771a87762a0c081ae6166958a954f80848820b2ab066937dc8b8379d65b1b039"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/3e/e9/54f232e659f635a000d94cfbca40b9d5d617707593c3d552ec14d3ba27f1/keyring-25.2.1.tar.gz"
    sha256 "daaffd42dbda25ddafb1ad5fec4024e5bbcfe424597ca1ca452b299861e49f1b"
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
    url "https://files.pythonhosted.org/packages/53/c6/79735ddcd38fe80066de96286085d2ddca10ddae3b31e23e93716d827ea9/okta-2.9.7.tar.gz"
    sha256 "c16dd08967321fd6f2332c2c4407562ee94551a828b9633ceef309b50faad941"
  end

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/53/4e/3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789f/orderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/31/a4/b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1/pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/e8/90/4cc84d60b32f3f069817705eaf7e07f3bceff050b56132885b71303aff88/pydash-8.0.1.tar.gz"
    sha256 "a24619643d3c054bfd56a9ae1cb7bd00e9774eaf369d7bb8d62b3daa2462bdbd"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/96/1d/7017750d93579b78bab3398ddd0e73bbd285d4f8fef3008a4fb8567e55d1/pyobjc_core-10.3.tar.gz"
    sha256 "875f2555b51a8a36cafbdb7d5d36f3452287a81bd5d7dc09aa6c309d638a9275"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/9a/0a/b16dfa284b937a0e7e4d14b1464aacab1fd408a410c0e80c8b2bba9ca4bd/pyobjc_framework_cocoa-10.3.tar.gz"
    sha256 "d39f90ffe04143911060c392e62b9514f14caaba119657d6e2b8b197af49e117"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https://files.pythonhosted.org/packages/61/e5/345d1195b1fca8597c20956404b44387752fc37e58d38599c3eb6b58b91e/pyobjc_framework_localauthentication-10.3.tar.gz"
    sha256 "073716dacdc1d8ca28db778ea133c9a4bff8678af9a6066a2a7e7043dc0e0169"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/6a/89/9d9251ee4a4aa62db11afc8e3cce6b026b149c31d035c72c6f1ea2674fe8/pyobjc_framework_security-10.3.tar.gz"
    sha256 "1be270a9205d9f392a658a267dec9ec602d6a98448419541f0005dc80da97013"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
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
    url "https://files.pythonhosted.org/packages/ce/6a/aa0a40b0889ec2eb81a02ee0daa6a34c6697a605cf62e6e857eead9e4f85/typing_extensions-4.12.0.tar.gz"
    sha256 "8cbcdc8606ebcb0d95453ad7dc5065e6237b6aa230a31e81d0f440c30fed5fd8"
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
