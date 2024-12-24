class Fava < Formula
  include Language::Python::Virtualenv

  desc "Web interface for the double-entry bookkeeping software Beancount"
  homepage "https://beancount.github.io/fava/"
  url "https://files.pythonhosted.org/packages/0f/7e/116ca196cbbd54c8457a15dd1a52dfab69cda390c89e38d333c76fa44f0f/fava-1.29.tar.gz"
  sha256 "519675e3615c8585ea3ed1dbe845a72a357ec6d2741afbbe4a8bd31fafa4567f"
  license "MIT"
  revision 2
  head "https://github.com/beancount/fava.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd2485a9e65a62eae03197ee74552fa32fd0cb400343592a8327eba5cbefcf82"
    sha256 cellar: :any,                 arm64_sonoma:  "a06440b846b76e5e4e1ab83f7c0f7521dff484dea2c62ffde4d16729a127e4a4"
    sha256 cellar: :any,                 arm64_ventura: "cbc76edbad145cbd2620c2212a307ef786c344c2e6c7ea4591ae08be6110dc9b"
    sha256 cellar: :any,                 sonoma:        "c63f16a7ceaef66f42e4355548eaebd1f604045e07cb46831e923cc82dfc9f6d"
    sha256 cellar: :any,                 ventura:       "4b1a6f4765cce072920c701207075c513caed493559593d0fdbc257527b608fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca843e939cdfef92e89a49c589c9824f8d95b76813f22d8bd6ae360cb37bfa50"
  end

  depends_on "rust" => :build # for watchfiles
  depends_on "certifi"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f6/40/318e58f669b1a9e00f5c4453910682e2d9dd594334539c7b7817dabb765f/anyio-4.7.0.tar.gz"
    sha256 "2f834749c602966b7d456a7567cafcb309f96482b5081d14ac93ccd457f9dd48"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/2a/74/f1bc80f23eeba13393b7222b11d95ca3af2c1e28edca18af487137eefed9/babel-2.16.0.tar.gz"
    sha256 "d1f3554ca26605fe173f3de0c65f750f5a42f924499bf134de6423582298e316"
  end

  resource "beancount" do
    url "https://files.pythonhosted.org/packages/f6/b1/2587862caf3367f2d421be9da278f547296b00b7f9610ca9a94fddd8c709/beancount-2.3.6.tar.gz"
    sha256 "801f93bed6b57d2e22436688c489d5a1bf1f76e210f3ced18680757e60d3475a"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/1b/fb/97839b95c2a2ea1ca91877a846988f90f4ca16ee42c0bb79e079171c0c06/bottle-0.13.2.tar.gz"
    sha256 "e53803b9d298c7d343d00ba7d27b0059415f04b9f6f40b8d58b5bf914ba9d348"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c3/38/a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7/cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/63/e2/f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1/cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/89/50/dff6380f1c7f84135484e176e0cac8690af72fa90e932ad2a0a60e28c69b/flask-3.1.0.tar.gz"
    sha256 "5f873c5184c897c8d9d1b05df1e3d01b14910ce69607a117bd3277098a5836ac"
  end

  resource "flask-babel" do
    url "https://files.pythonhosted.org/packages/58/1a/4c65e3b90bda699a637bfb7fb96818b0a9bbff7636ea91aade67f6020a31/flask_babel-4.0.0.tar.gz"
    sha256 "dbeab4027a3f4a87678a11686496e98e1492eb793cbdd77ab50f4e9a2602a593"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/81/56/d70d66ed1b5ab5f6c27bf80ec889585ad8f865ff32acbafd3b2ef0bfb5d0/google_api_core-2.24.0.tar.gz"
    sha256 "e255640547a597a4da010876d333208ddac417d60add22b6851a0c66a831fcaf"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/01/e6/91022ee180ea77ab56147602690bb9b03459b19bf478b64e89be5f5757d5/google_api_python_client-2.156.0.tar.gz"
    sha256 "b809c111ded61716a9c1c7936e6899053f13bae3defcdfda904bd2ca68065b9c"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/46/af/b25763b9d35dfc2c6f9c3ec34d8d3f1ba760af3a7b7e8d5c5f0579522c45/google_auth-2.37.0.tar.gz"
    sha256 "0054623abf1f9c83492c63d3f47e77f0a544caa3d40b2d98e099a611c2dd5d00"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/ff/a7/8e9cccdb1c49870de6faea2a2764fa23f627dd290633103540209f03524c/googleapis_common_protos-1.66.0.tar.gz"
    sha256 "c3e7b33d15fdca5374cc0a7346dd92ffa847425cc4ea941d970f13680052ec8c"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/ab/23/9894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013/jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/a0/61/d3c0c21280ba1fc348822a4410847cf78f99bba8625755a5062a44d2e228/markdown2-2.5.2.tar.gz"
    sha256 "3ac02226a901c4b2f6fc21dbd17c26d118d2c25bcbb28cee093a1f8b5c46f3f1"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/51/78/65922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178f/more-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pdfminer2" do
    url "https://files.pythonhosted.org/packages/e0/55/5e235321d7494772264b577a8569c102b9d9ef867f7239d14d562e89bed9/pdfminer2-20151206.macosx-10.10-x86_64.tar.gz"
    sha256 "9c0599bfde105a8d58e3f679c31ab84871dc9bd3debf1be6511e1abaa4db867f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/7e/05/74417b2061e1bf1b82776037cad97094228fa1c1b6e82d08a78d3fb6ddb6/proto_plus-1.25.0.tar.gz"
    sha256 "fbb17f57f7bd05a68b7707e745e26528b0b3c34e378db91eef93912c54982d91"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/a5/73/4e6295c1420a9d20c9c351db3a36109b4c9aa601916cb7c6871e3196a1ca/protobuf-5.29.2.tar.gz"
    sha256 "b2cc8e8bb7c9326996f0e160137b0861f1a82162502658df2951209d0cb0309e"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8c/d5/e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2/pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/05/35/30e0d83068951d90a01852cb1cef56e5d8a09d20c7f511634cc2f7e0372a/pytest-8.3.4.tar.gz"
    sha256 "965370d062bce11e73868e0335abac31b4d3de0e82f4007408d242b4f8610761"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/3d/29/085111f19717f865eceaf0d4397bf3e76b08d60428b076b64e2a1903706d/simplejson-3.19.3.tar.gz"
    sha256 "8e086896c36210ab6050f2f9f095a5f1e03c83fa0e7f296d6cba425411364680"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/3c/7e/4569184ea04b501840771b8fcecee19b2233a8b72c196061263c0ef23c0b/watchfiles-1.0.3.tar.gz"
    sha256 "f3ff7da165c99a5412fe5dd2304dd2dbaaaa5da718aad942dcb3a178eaa70c56"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"fava", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    # Find an available port
    port = free_port

    (testpath/"example.ledger").write <<~EOS
      2020-01-01 open Assets:Checking
      2020-01-01 open Equity:Opening-Balances
      2020-01-01 txn "Opening Balance"
        Assets:Checking 10.00 USD
        Equity:Opening-Balances
    EOS

    fork do
      exec bin/"fava", "--port=#{port}", testpath/"example.ledger"
    end

    # Wait for fava to start up
    sleep 10

    cmd = "curl -sIm1 -XGET http://localhost:#{port}/beancount/income_statement/"
    assert_match(/200 OK/m, shell_output(cmd))
  end
end
