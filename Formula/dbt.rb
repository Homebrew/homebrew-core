class Dbt < Formula
  include Language::Python::Virtualenv

  desc "Data build tool"
  homepage "https://github.com/fishtown-analytics/dbt"
  url "https://files.pythonhosted.org/packages/15/57/0a088bf55340158c7eb06e33a89018a0d9096a7539f54728d1e8277b3cdc/dbt-0.8.3.tar.gz"
  sha256 "5c974eb2a3504c736371fbf7c97621fc0ed5b077a4c44862799bb6789438ae31"

  head "https://github.com/fishtown-analytics/dbt.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "ee921769dc8a305b00c1d649003194bedf7c77e8275207c9366a6e3ac90f95fe" => :sierra
    sha256 "c8edbcf5e25875505b2cb009db44f7dd67fb2b6d95bfc2bd063b200c6ce7646e" => :el_capitan
    sha256 "a6167c7ad0965d919337dc61242f0f27e038f0e72aaec5ad639637fbf73dc4a1" => :yosemite
  end

  depends_on "python3"
  depends_on "openssl"
  depends_on "postgresql"

  resource "amqp" do
    url "https://files.pythonhosted.org/packages/cc/a4/f265c6f9a7eb1dd45d36d9ab775520e07ff575b11ad21156f9866da047b2/amqp-1.4.9.tar.gz"
    sha256 "2dea4d16d073c902c3b89d9b96620fb6729ac0f7a923bbc777cb4ad827c0c61a"
  end

  resource "anyjson" do
    url "https://files.pythonhosted.org/packages/c3/4d/d4089e1a3dd25b46bebdb55a992b0797cff657b4477bc32ce28038fdecbc/anyjson-0.3.3.tar.gz"
    sha256 "37812d863c9ad3e35c0734c42e0bf0320ce8c3bed82cd20ad54cb34d158157ba"
  end

  resource "billiard" do
    url "https://files.pythonhosted.org/packages/64/a6/d7b6fb7bd0a4680a41f1d4b27061c7b768c673070ba8ac116f865de4e7ca/billiard-3.3.0.23.tar.gz"
    sha256 "692a2a5a55ee39a42bcb7557930e2541da85df9ea81c6e24827f63b80cd39d0b"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/58/61/50d2e459049c5dbc963473a71fae928ac0e58ffe3fe7afd24c817ee210b9/boto3-1.4.4.tar.gz"
    sha256 "518f724c4758e5a5bed114fbcbd1cf470a15306d416ff421a025b76f1d390939"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/18/18/3b0dd194d3f45412e0f25819c9f0eb7de3e8dd248e41187ecd6981e2bdfd/botocore-1.5.14.tar.gz"
    sha256 "0eda21e36edaa0a9f8312f826e0e6fbb844f9193719654e99efe8178fedeb54c"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/dc/64/16cbf95e0ac473503c5dcd61aefbbab9f12e1875f40a0aaff566a1236ac4/cachetools-2.0.0.tar.gz"
    sha256 "715a7202240dc20dbe83abdb2d804d543e2d4f07af146f53c82166bd75f3a628"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/ea/a6/6da0bac3ea8abbc2763fd2664af2955702f97f140f2d7277069445532b7c/celery-3.1.23.tar.gz"
    sha256 "1a359c815837f9dbf193a7dbc6addafa34612c077ff70c66e3b16e14eebd2418"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/dd/0e/1e3b58c861d40a9ca2d7ea4ccf47271d4456ae4294c5998ad817bd1b4396/certifi-2017.4.17.tar.gz"
    sha256 "f7527ebf7461582ce95f7a9e03dd141ce810d40590834f4ec20cddd54234c10a"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"
    sha256 "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/99/df/71c7260003f5c469cec3db4c547115df39e9ce6c719a99e067ba0e78fd8a/cryptography-1.7.2.tar.gz"
    sha256 "878cb68b3da3d493ffd68f36db11c29deee623671d3287c3f8d685117ffda9a9"
  end

  resource "csvkit" do
    url "https://files.pythonhosted.org/packages/f6/5a/4843db5d3ea69c4984fbfd64859e5ae32847e9384ccc82849c27fd33720b/csvkit-0.9.1.tar.gz"
    sha256 "92f8b8647becb5cb1dccb3af92a13a4e85702d42ba465ce8447881fb38c9f93a"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/cc/ac/5a16f1fc0506ff72fcc8fd4e858e3a1c231f224ab79bb7c4c9b2094cc570/decorator-4.0.11.tar.gz"
    sha256 "953d6bf082b100f43229cf547f4f97f97e970f5ad645ee7601d55ff87afdfe76"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/05/25/7b5484aca5d46915493f1fd4ecb63c38c333bd32aa9ad6e19da8d08895ae/docutils-0.13.1.tar.gz"
    sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/1b/92/b111f76e54d2be11375b47b213b56687214f258fd9dae703546d30b837be/gevent-1.2.2.tar.gz"
    sha256 "4791c8ae9c57d6f153354736e1ccab1e2baf6c8d9ae5a77a9ac90f41e2966b2d"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/1a/88/e1d20a80c357a48b024615b49fe7ea93f638eb3ba27106cfce77879d7d48/google-auth-1.0.1.tar.gz"
    sha256 "dd7b6e5f3bd15c0f7cfee63a266acea40c779da0a924b475bc1812e6e10687e1"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/43/20/c9adf8ee79ef9ab718945b317d3bad5ff36108bf7b1426e4d2f16e76d9d5/google-auth-httplib2-0.0.2.tar.gz"
    sha256 "312464fb81d2a941aa6541410ef61de9fa788753414ee5f2f1d74153d9c1540d"
  end

  resource "google-cloud-bigquery" do
    url "https://files.pythonhosted.org/packages/c1/fc/91a8665f9ec8e5e251fa54f7e775f9c744fef7e65168431b04fb97a904de/google-cloud-bigquery-0.24.0.tar.gz"
    sha256 "3455d9ba66c876a37ff73108a95771edce4e082537d6119c19dcc1371f1b086a"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/78/fd/3efe732d40facc94fca4b8e26f7840ee16b00200aac2078f2062f3fffa5f/google-cloud-core-0.24.1.tar.gz"
    sha256 "fe73253dd98965bdd02ac6951afabe9e09bda203fc8065bf285d8d13172afc9c"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/96/6a/34759a4a2119a8aae0b19d045917ee4a39ffaaeda2df3a892730fdcda408/googleapis-common-protos-1.5.2.tar.gz"
    sha256 "f94cc66efba677a086b8b17b1240239433495b77631cd410f70151a8ff14435d"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/be/76/82af375d98724054b7e273b5d9369346937324f9bcc20980b45b068ef0b0/greenlet-0.4.12.tar.gz"
    sha256 "e4c99c6010a5d153d481fdaf63b8a0782825c0721506d880403a3b9b82ae347e"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/e4/2e/a7e27d2c36076efeb8c0e519758968b20389adf57a9ce3af139891af2696/httplib2-0.10.3.tar.gz"
    sha256 "e404d3b7bd86c1bc931906098e7c1305d6a3a6dcef141b8bb1059903abb3ceeb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/33/0b/22c069f40dddfe4fc8600140155168393178879652961e7ae0dc0707b776/ijson-2.3.tar.gz"
    sha256 "ef5f9f6bf9e44f2e1721e72bcc82c7ac6bb012b525e0f8642dedf7ddc44cf474"
  end

  resource "jdcal" do
    url "https://files.pythonhosted.org/packages/9b/fa/40beb2aa43a13f740dd5be367a10a03270043787833409c61b79e69f1dfd/jdcal-1.3.tar.gz"
    sha256 "b760160f8dc8cc51d17875c6b663fafe64be699e10ce34b6a95184b5aa0fdc9e"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/90/61/f820ff0076a2599dd39406dcb858ecb239438c02ce706c8e91131ab9c7f1/Jinja2-2.9.6.tar.gz"
    sha256 "ddaa01a212cd6d641401cb01b605f4a4d9f37bfc93043d7f760ec70fb99ff9ff"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "kombu" do
    url "https://files.pythonhosted.org/packages/38/69/8d603be2df979f1b9ffefae1e51cde664c52a258aff6e8c3253032c8f2c8/kombu-3.0.37.tar.gz"
    sha256 "e064a00c66b4d1058cd2b0523fb8d98c82c18450244177b6c0f7913016642650"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c2/93/dbb41b03cf7c878a7409c8e92226531f840a423c9309ea534873a83c9192/networkx-1.11.tar.gz"
    sha256 "0d0e70e10dfb47601cbb3425a00e03e2a2e97477be6f80638fef91d54dd1e4b8"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/c8/bf/628855545eb7782be701ec1c51b2e84e0cf9325e36daa09fddab7894954f/openpyxl-2.2.0-b1.tar.gz"
    sha256 "3394d92810796164ae1b12bb58c91b332174769ed0df5b7396a81471b9ba2058"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/56/28/6263d846f60dad93939fd3a22d712d6bae3bf3484332d22bd5933dec8c99/protobuf-3.3.0.tar.gz"
    sha256 "1cbcee2c45773f57cb6de7ee0eceb97f92b9b69c0178305509b162c0160c1f04"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/f8/e9/5793369ce8a41bf5467623ded8d59a434dfef9c136351aca4e70c2657ba0/psycopg2-2.7.1.tar.gz"
    sha256 "86c9355f5374b008c8479bc00023b295c07d508f7c3b91dbd2e74f8925b1d9c6"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/cf/57/d4097cea8caf360ffe0c5d6f25c2cb9317500cdc000fd02a741ba6e64c9e/pyasn1-modules-0.0.9.tar.gz"
    sha256 "be0e4157e4a53551279d6c6e366b080527f5fd068616835b4abf32c14f657f5f"
  end

  resource "PyContracts" do
    url "https://files.pythonhosted.org/packages/05/cf/93c6bba08bf268063c13cd9ad7656c9ab12d15cd7d88a9abe38e7eb0c74e/PyContracts-1.7.15.tar.gz"
    sha256 "24bf3ab5cfd61d0e296af82fb8b73ba875ea09733a8ca562f53016cf980dc469"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b7/fb/5ea74c6dfe6c4937f2ca2e609155c0d97bdf00f8aa306deb25c8f547fdb8/pycryptodome-3.4.6.tar.gz"
    sha256 "df1be662060cf3abdcf2086ebb401f750744106425ddebf74c57feab410e4923"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/75/c5/85d027471fa665f8c8b8eb0b925f9d84b4eee745a257b16de4957de99e81/python-dateutil-2.2.tar.gz"
    sha256 "eec865307ebe7f329a6a9945c15453265a449cdaaf3710340828a1934d53e468"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/68/44/5efe9e98ad83ef5b742ce62a15bea609ed5a0d1caf35b79257ddb324031a/redis-2.10.5.tar.gz"
    sha256 "5dfbae6acfc54edf0a7a415b99e0b21c0a3c27a7f787b292eea727b1facc5533"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2c/b5/2b6e8ef8dd18203b6399e9f28c7d54f6de7b7549853fe36d575bd31e29a7/requests-2.18.1.tar.gz"
    sha256 "c6f3bdf4a4323ac7b45d01e04a6f6c20e32a052cd04de81e05103abc049ad9b9"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/14/89/adf8b72371e37f3ca69c6cb8ab6319d009c4a24b04a31399e5bd77d9bb57/rsa-3.4.2.tar.gz"
    sha256 "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/8b/13/517e8ec7c13f0bb002be33fbf53c4e3198c55bb03148827d72064426fe6e/s3transfer-0.1.10.tar.gz"
    sha256 "ba1a9104939b7c0331dc4dd234d79afeed8b66edce77bbeeecd4f56de74a0fc1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "snowflake-connector-python" do
    url "https://files.pythonhosted.org/packages/cb/f2/63cbb01a9164aa195ae7d34ddba411f52327dbf3f468219673b1ba755da4/snowflake-connector-python-1.3.16.tar.gz"
    sha256 "e90e305b36b6542a4ed423f794dcc7b38abafbfc30945951894e85a88789f3fa"
  end

  resource "snowplow-tracker" do
    url "https://files.pythonhosted.org/packages/6d/af/7fea9ae4876a830d70dd17a24e647dd472b3b9f1d1f1dae75a2d44042505/snowplow-tracker-0.7.2.tar.gz"
    sha256 "4eac1d5fe1e6d7d7d62fe4a780d9b5795c587ac1bf0430b1225bc744ab638268"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/59/f1/28f2205c3175e6bf32300c0f30f9d91dbc9eb910debbff3ffecb88d18528/SQLAlchemy-1.1.11.tar.gz"
    sha256 "76f76965e9a968ba3aecd2a8bc0d991cea04fd9a182e6c95c81f1551487b0211"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/45/67/14bdaeff492e6d03a055fe80502bae10b679891c25a0dc59be2fe51002f8/sqlparse-0.2.3.tar.gz"
    sha256 "becd7cc7cebbdf311de8ceedfcf2bd2403297024418801947f8c953025beeff8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/96/d9/40e4e515d3e17ed0adbbde1078e8518f8c4e3628496b56eb8f026a02b9e4/urllib3-1.21.1.tar.gz"
    sha256 "b14486978518ca0901a76ba973d7821047409d7f726f22156b24e83fd71382a5"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/c3/81/c84f8a3e723b760fdd1c41fc80201cb80cd29c1bce5159d8918c58df7d2a/voluptuous-0.10.5.tar.gz"
    sha256 "7a7466f8dc3666a292d186d1d871a47bf2120836ccb900d5ba904674957a2396"
  end

  resource "xlrd" do
    url "https://files.pythonhosted.org/packages/42/85/25caf967c2d496067489e0bb32df069a8361e1fd96a7e9f35408e56b3aab/xlrd-1.0.0.tar.gz"
    sha256 "0ff87dd5d50425084f7219cb6f86bb3eb5aa29063f53d50bf270ed007e941069"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    resource("cryptography").stage do
      if MacOS.version < :sierra
        # Fixes .../cryptography/hazmat/bindings/_openssl.so: Symbol not found: _getentropy
        # Reported 20 Dec 2016 https://github.com/pyca/cryptography/issues/3332
        inreplace "src/_cffi_src/openssl/src/osrandom_engine.h",
          "#elif defined(BSD) && defined(SYS_getentropy)",
          "#elif defined(BSD) && defined(SYS_getentropy) && 0"
      end
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - ["cryptography"]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath

    bin.install_symlink "#{libexec}/bin/dbt" => "dbt"
  end

  test do
    (testpath/"dbt_project.yml").write("{name: 'test', version: '0.0.1', profile: 'default'}")
    (testpath/".dbt/profiles.yml").write(
      "{default: {outputs: {default: {type: 'postgres', threads: 1, host: 'localhost', port: 5432,
      user: 'root', pass: 'password', dbname: 'test', schema: 'test'}}}, target: 'default'}",
    )
    (testpath/"models/test.sql").write("select * from test")
    system "#{bin}/dbt", "test"
  end
end
