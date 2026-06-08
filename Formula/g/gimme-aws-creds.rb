class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/63/73/9e508d37d4d301f6a3811fdc0b0a076696de87f82ad8a81ec28c3e6befb5/gimme_aws_creds-2.8.2.tar.gz"
  sha256 "12784f4b749617d7391bf2056373990277858dc9886328832b545e9e334f24d3"
  license "Apache-2.0"
  revision 13
  head "https://github.com/Nike-Inc/gimme-aws-creds.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "564cc36bd46ef195a59dcb35e3bfa3f356305c75626b22d5e363ab78c78b2309"
    sha256 cellar: :any, arm64_sequoia: "eb439eda1403d7dabbe624400964327f7745aa6a1b8c3b45f87f17de79f0d5ca"
    sha256 cellar: :any, arm64_sonoma:  "c3c4f3aba2a941b7ef7d360c9b947697afd7f1a13b3abb7726505b0890ac186c"
    sha256 cellar: :any, sonoma:        "19eec3bd1db97409d75f02725c3a2fb89991d3924a4c4bb7aa9916b7b8640be3"
    sha256 cellar: :any, arm64_linux:   "d28d264e5c3cb63b117579e4efbe32917e27ceebe18d6814cce343d834cf3855"
    sha256 cellar: :any, x86_64_linux:  "d9dfd854eaa9a36e4312dd2cb7c0ad35a2333c626f9049d59a9996df9c3c08e8"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  fails_with :clang do
    build 1699
    cause "pyobjc-core uses `-fdisable-block-signature-string`"
  end

  # Extra package resources are set here for platform-specific dependencies
  # since the output of `bump-formula-pr` and `update-python-resources` is
  # impacted by whether command is run on macOS or Linux. Remove if Homebrew
  # logic is enhanced to handle this. Also, occasionally check if any of these
  # Python dependencies are no longer used.
  #
  # macOS: `pyobjc-framework-localauthentication`, ...
  # - gimme-aws-creds
  #   ├── ctap-keyring-device
  #       └── pyobjc-framework-localauthentication
  #           ├── pyobjc-core
  #           ├── ...
  pypi_packages exclude_packages: %w[certifi cryptography],
                extra_packages:   %w[jeepney pyobjc-framework-localauthentication secretstorage]

  resource "aenum" do
    url "https://files.pythonhosted.org/packages/07/e9/8b283567c1fef7c24d1f390b37daede8b61593d8cdaffb8e95d571699e83/aenum-3.1.17.tar.gz"
    sha256 "a969a4516b194895de72c875ece355f17c0d272146f7fda346ef74f93cf4d5ba"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/33/c6/61a2d7b7572279226bb2e7f61d7a19ca7c90da0329c93fa0d560cbf288d8/aiohappyeyeballs-2.6.2.tar.gz"
    sha256 "e202810ee718bd01fc6ef49e8ea53d023d5cb6b581076d7925aa499fa55dbe64"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/ee/ab/93ce242f899b68c51b0578c027aafa791ab3614cb9345fa5d37b5f5c8e3e/aiohttp-3.14.0.tar.gz"
    sha256 "2882de819734c715fd1b9c11c97e09fa020d14438203d1d354d8ed1702791c9b"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/97/da/229987ebb70daf5928f959aa8f4dd77dfcf425e6b0e7ff03aaef61ccc333/boto3-1.43.19.tar.gz"
    sha256 "8b84704719dd3960ac12a8f37d9ff5adb853715baa9742f84fdbe2de0305c4cb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e2/a7/298986789785b74a954e2347114993be7e6b070417159125a6865f2687b6/botocore-1.43.19.tar.gz"
    sha256 "18ac2fdd76c89b940707eb10493ff58678adad337d03215caec2d408ccd43cc0"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
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
    url "https://files.pythonhosted.org/packages/1f/ba/e0461697020839f60741e493fc42b20a4cd3f91594ed3228f65ae9a50aee/flatdict-4.1.0.tar.gz"
    sha256 "63bcd906a0859d91d0aace44b327178706c7fcf85a88c7ccf0825628376ad66b"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "furl" do
    url "https://files.pythonhosted.org/packages/53/e4/203a76fa2ef46cdb0a618295cc115220cbb874229d4d8721068335eb87f0/furl-2.1.4.tar.gz"
    sha256 "877657501266c929269739fb5f5980534a41abd6bbabcb367c136d1d3b2a6015"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14
    # PR ref: https://github.com/html5lib/html5lib-python/pull/589
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
    end

    # Remove pkg_resources for setuptools 81+ compatibility
    # https://github.com/html5lib/html5lib-python/pull/592
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/1dbc19cd6db72cb919885827bc4883423e0cb647.patch?full_index=1"
      sha256 "5951b823f353dd70806ad6e163ab8f46899496c1e8bb53970c99abe8d1df1a78"
    end
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/b9/28/99c51f664567218d824af024c0251650fb27e4ca066df188dab0769c5b91/idna-3.17.tar.gz"
    sha256 "5eb0cb53bc467c12eadcf6de83163ad8527cec9416f44b9b61b19caedad2b87f"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/36/cf/ea4ef2920830dea3f5ab2ea4da6fb67724e6dca80ee2553788c3607243d0/jaraco_functools-4.5.0.tar.gz"
    sha256 "3bb5665ea4a020cf78a7040e89154c77edadb3ca74f366479669c5999aa70b03"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jwcrypto" do
    url "https://files.pythonhosted.org/packages/8c/90/f065668004d22715c1940d6e88e4c3afc8ee16d5664e4478d2c8fd23a250/jwcrypto-1.5.7.tar.gz"
    sha256 "70204d7cca406eda8c82352e3c41ba2d946610dafd19e54403f0a1f4f18633c6"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/1c/25/c896ce27690285ea67893b74049359695e182093b75cb8f0ed41e28006bc/okta-2.9.13.tar.gz"
    sha256 "8d8e926751b7f8daae1794df2ec1b0e93f563b8b26781613d205cb9d10e837ef"
  end

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/5c/62/61ad51f6c19d495970230a7747147ce7ed3c3a63c2af4ebfdb1f6d738703/orderedmultidict-1.0.2.tar.gz"
    sha256 "16a7ae8432e02cc987d2d6d5af2df5938258f87c870675c73ee77a0920e6f4a6"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/75/c1/1c55272f49d761cec38ddb80be9817935b9c91ebd6a8988e10f532868d56/pydash-8.0.6.tar.gz"
    sha256 "b2821547e9723f69cf3a986be4db64de41730be149b2641947ecd12e1e11025a"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/2a/e8/a6cc12669211e7c9b29e8f26bf2159e67c7a73555dc229018abf46d8167a/pyobjc_core-12.2.tar.gz"
    sha256 "51d7de4cfa32f508c6a7aac31f131b12d5e196a8dcf588e6e8d7e6337224f66d"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/6d/cc/927169225e72bab9c9b44285656768fb75052a0bc85fdbca62740e1ca43c/pyobjc_framework_cocoa-12.2.tar.gz"
    sha256 "20b392e2b7241caad0538dfde12143343e5dfe48f72e7df660a7548e635903dc"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https://files.pythonhosted.org/packages/3b/bb/68ff2b154ed783d39a1752cbbb7dc9d0ce55c17097dc00fe56d9080c6349/pyobjc_framework_localauthentication-12.2.tar.gz"
    sha256 "e1d734db5ddf35093307e213115bd122ef8712463be048eabfa4062022373e21"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/e3/3c/7778dd8e196373feabc54841b87e495148da3fe20d305f39397546afaaee/pyobjc_framework_security-12.2.tar.gz"
    sha256 "ef4d2d852a09360929e284c6f355964d84ac88b170207de1ac299fa1e1c33e40"
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
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e0/1f/12417f7f493fc45e1f9fd5d4a9b6c125cf8d2cf3f8ddbdfab3e76406e9d6/s3transfer-0.18.0.tar.gz"
    sha256 "3760b8b7ec1315da54048b2d626276732bee4300d054d492d4e1d43e20d4ecbd"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/2c/0a5f6f8ee0d5589e48c7640213ed5175d52cf540a06725b628cc1a45d6ce/soupsieve-2.8.4.tar.gz"
    sha256 "e121fd02e975c695e4e9e8774a5ee35d74714b59307868dcc5319ad2d9e3328e"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
  end

  def install
    if OS.mac?
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      without = %w[jeepney secretstorage]
    else
      without = resources.filter_map { |r| r.name if r.name.start_with?("pyobjc") }
    end
    virtualenv_install_with_resources(without:)
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
