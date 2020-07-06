class Fava < Formula
  include Language::Python::Virtualenv

  desc "Web interface for the double-entry bookkeeping software Beancount"
  homepage "https://beancount.github.io/fava/"
  url "https://files.pythonhosted.org/packages/5e/42/d9f234080d5c48cd59ac0dc85b492188f2d7316b6a1790edaa65807a32bb/fava-1.15.tar.gz"
  sha256 "ff691c328cc524fb752c20b5c4ad2f23817caa2e0d9ec791f00a47e96a84ee0c"
  license "MIT"
  head "https://github.com/beancount/fava.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b29afa03c4a096058a3a3ccbd6b9309fd27fc834f1d63b7eebddc44b7628e99c" => :catalina
    sha256 "ae76d1333a3f1b0d84d6cb8cc32a6cc31e1d77f0de4a933a8d5e81ec40d8ccaf" => :mojave
    sha256 "96471a458d497ccd045661125f1ed4fb49a923084480f11463684e212c5f72d0" => :high_sierra
  end

  depends_on "python@3.8"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/34/18/8706cfa5b2c73f5a549fdc0ef2e24db71812a2685959cff31cbdfc010136/Babel-2.8.0.tar.gz"
    sha256 "1aac2ae2d0d8ea368fa90906567f5c08463d98ade155c0c4bfedd6a0f7160e38"
  end

  resource "beancount" do
    url "https://files.pythonhosted.org/packages/26/d6/9cb23ad3af828ebba10deda85dc28c0985acfbfdce3fb6c4b76ec69389d3/beancount-2.3.0.tar.gz"
    sha256 "9a6d9692435007195aae29a20328fb11d0126ff03db66322a79a894b1f422712"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c6/62/8a2bef01214eeaa5a4489eca7104e152968729512ee33cb5fbbc37a896b7/beautifulsoup4-4.9.1.tar.gz"
    sha256 "73cc4d115b96f79c7d77c1c7f7a0a8d4c57860d1041df407dd1aae7f07a77fd7"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/d9/4f/57887a07944140dae0d039d8bc270c249fc7fc4a00744effd73ae2cde0a9/bottle-0.12.18.tar.gz"
    sha256 "0819b74b145a7def225c0e83b16a4d5711fde751cd92bae467a69efce720f69e"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/30/62/88fda08df9053141647b6941141b71b4c2a23d0fabab485feb917428ab46/cachetools-4.1.0.tar.gz"
    sha256 "1d057645db16ca7fe1f3bd953558897603d6f0b9c51ed9d11eb4d071ec4e2aab"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b4/19/53433f37a31543364c8676f30b291d128cdf4cd5b31b755b7890f8e89ac8/certifi-2020.4.5.2.tar.gz"
    sha256 "5ad7e9a056d25ffa5082862e36f119f7f7cec6457fa07ee2f8c339814b80c9b1"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/57/c9/410e2f96de941759719f4ac1f595b1ed65e423c354bed1b2eb3e09aaf18d/cheroot-8.3.0.tar.gz"
    sha256 "a0577e1f28661727d472671a7cc4e0c12ea0cbc5220265e70f00a8b8cb628931"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/4e/0b/cb02268c90e67545a0e3a37ea1ca3d45de3aca43ceb7dbf1712fb5127d5d/Flask-1.1.2.tar.gz"
    sha256 "4efa1ae2d7c9865af48986de8aeb8504bf32c7f3d6fdc9353d34b21f4b127060"
  end

  resource "Flask-Babel" do
    url "https://files.pythonhosted.org/packages/7a/73/e4a9532ca11daeead1a99251f2ec1a5faf98117b83dbfe1b30535004cd98/Flask-Babel-1.0.0.tar.gz"
    sha256 "d6a70468f9a8919d59fba2a291a003da3a05ff884275dddbd965f3b98b09ab3e"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/ed/b9/8d5ab480045ae95cc6ce6d4f5ca5917af9016a195ea21864c801c35a9197/google-api-core-1.20.1.tar.gz"
    sha256 "6b757736bbc699db858794e9b71e2bbf17996075773a40551ef5e6b0fad2a2f9"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/31/8d/06ee9dd2f50eb111d2fc19a217a38b25e0f431ef4e0e7efc2efce2d3daf0/google-api-python-client-1.9.3.tar.gz"
    sha256 "220349ce189a85229fc46875d467101318495a4a735c0ff2f165b9bdbc7511a0"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/ad/17/fa3531cc75956f48baa0fd5b6f69b768cb763c26b8064363954842fa4ac6/google-auth-1.17.2.tar.gz"
    sha256 "e634b649967d83c02dd386ecae9ce4a571528d59d51a4228757e45f5404a060b"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/e7/32/ac7f30b742276b4911a1439c5291abab1b797ccfd30bc923c5ad67892b13/google-auth-httplib2-0.0.3.tar.gz"
    sha256 "098fade613c25b4527b2c08fa42d11f3c2037dda8995d86de0745228e965d445"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/95/3f/a1282d82def57e0c28bab597d25785774a4e64433aac9cc136e65c500da8/googleapis-common-protos-1.52.0.tar.gz"
    sha256 "560716c807117394da12cecb0a54da5a451b5cf9866f1d37e9a5e2329a665351"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/98/3f/0769a851fbb0ecc458260055da67d550d3015ebe6b8b861c79ad00147bb9/httplib2-0.18.1.tar.gz"
    sha256 "8af66c1c52c7ffe1aa5dc4bcd7c769885254b0756e6e69f953c7f0ab49a70ba3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b/itsdangerous-1.1.0.tar.gz"
    sha256 "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19"
  end

  resource "jaraco.functools" do
    url "https://files.pythonhosted.org/packages/89/e1/773ecbf42ada8dc31459837c76316478df975cf6d9fcc171075548bd7cac/jaraco.functools-3.0.1.tar.gz"
    sha256 "9fedc4be3117512ca3e03e1b2ffa7a6a6ffa589bfb7d02bfb324e55d493b94f4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/03/a8/73d795778143be51d8b86750b371b3efcd7139987f71618ad9f4b8b65543/lxml-4.5.1.tar.gz"
    sha256 "27ee0faf8077c7c1a589573b1450743011117f1aa1a91d5ae776bbc5ca6070f2"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/14/69/c542025f80916457ff4fe962404a27ab6417d43822fe54bf88ee2dd1b36f/markdown2-2.3.9.tar.gz"
    sha256 "89526090907ae5ece66d783c434b35c29ee500c1986309e306ce2346273ada6a"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/67/4a/16cb3acf64709eb0164e49ba463a42dc45366995848c4f0cf770f57b8120/more-itertools-8.4.0.tar.gz"
    sha256 "68c70cc7167bdf5c7c9d8f6954a7837089c6a36bf565383919bb595efb8a17e5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/ab/e7/8001b5fc971078a15f57cb56e15b699cb0c0f43b1dffaa2fae39961d80da/protobuf-3.12.2.tar.gz"
    sha256 "49ef8ab4c27812a89a76fa894fe7a08f42f2147078392c0dee51d4a444ef6df5"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/1b/2b/396ff4b82f58c1152daf3b335999b493541a9d141bf102e22b4294b3b6aa/py-1.8.2.tar.gz"
    sha256 "f3b3a4c36512a4c4f024041ab51866f11761cc169670204b235f6b20523d4e6b"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/8f/c4/e4a645f8a3d6c6993cb3934ee593e705947dfafad4ca5148b9a0fde7359c/pytest-5.4.3.tar.gz"
    sha256 "7979331bfcba207414f5e1263b5a0f8f521d0f457318836a7355531ed1a4c7d8"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/e3/85/1aff76b966622868a73717abd8b501a3c91890e23a65e5f574ff6df1970f/python-magic-0.4.18.tar.gz"
    sha256 "b757db2a5289ea3f1ced9e60f072965243ea43a2221430048fd8cacab17be0ce"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz"
    sha256 "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/a2/d5/04b8a9719149583fec76efdff2e7a81c6e3cc34909ee818d3fbf115edc2e/rsa-4.6.tar.gz"
    sha256 "109ea5a66744dd859bf16fe904b8d8b627adafb9408753161e766a92e7d681fa"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/98/87/a7b98aa9256c8843f92878966dc3d8d914c14aad97e2c5ce4798d5743e07/simplejson-3.17.0.tar.gz"
    sha256 "2b4b2b738b3b99819a17feaf118265d0753d5536049ea570b3c43b51c4701e81"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/3e/db/5ba900920642414333bdc3cb397075381d63eafc7e75c2373bbc560a9fa1/soupsieve-2.0.1.tar.gz"
    sha256 "a59dc181727e95d25f781f0eb4fd1825ff45590ec8ff49eadfd7f1a537cc0232"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/42/da/fa9aca2d866f932f17703b3b5edb7b17114bb261122b6e535ef0d9f618f8/uritemplate-3.0.1.tar.gz"
    sha256 "5af8ad10cec94f215e3f48112de2022e1d5a37ed427fbd88652fa908f2ab7cae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2e/30/268d9d3ed18439b6983a8e630cd52d81fd7460a152d6e801d1b8394e51a1/wcwidth-0.2.4.tar.gz"
    sha256 "8c6b5b6ee1360b842645f336d9e5d68c55817c26d3050f46b235ef2bc650e48f"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
  end

  def install
    virtualenv_install_with_resources
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
      exec "#{bin}/fava", "--port=#{port}", "#{testpath}/example.ledger"
    end

    # Wait for fava to start up
    sleep 5

    cmd = "curl -sIm1 -XGET http://localhost:#{port}/beancount/income_statement/"
    assert_match(/200 OK/m, shell_output(cmd))
  end
end
