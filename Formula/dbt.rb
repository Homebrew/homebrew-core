class Dbt < Formula
  include Language::Python::Virtualenv

  desc "Data build tool"
  homepage "https://github.com/fishtown-analytics/dbt"
  url "https://files.pythonhosted.org/packages/1e/a0/d75ae9f42939e40442422592847f10339e68cfcf83fa2566142c5eb2183b/dbt-0.7.1.tar.gz"
  sha256 "47cfb828590e25420ebbcdbfcad2e5afde36b3e4ed4d6e0618401850eb6ab368"

  head "https://github.com/fishtown-analytics/dbt.git", :branch => "development"

  bottle do
    sha256 "8c2bb62b47e9719c1190fe29ae189baf051fe3108af286f963ea4bb9182e3164" => :sierra
    sha256 "e1f112423c0bc0a70ce2d253a13e5b7994ee63ae6731fab9cfeaf8e253a6b64f" => :el_capitan
    sha256 "db6fe641839c015bd68b29fabe8a880e5c0353ef7e9af2fb22dbb7902645bcb6" => :yosemite
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
    url "https://files.pythonhosted.org/packages/90/fe/b941e83b5b9a0bdc6b1fd999302eeedd1bcb57c662927ab88427a6ed05cd/boto3-1.4.3.tar.gz"
    sha256 "d221b19d513f039d3980075cdd4cece51ec60f5034a8b1721cbbf0073343e5e8"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/75/2b/5db4c3961b9dd8315b2e656e3fbc917cb0b5f6b3ec93b42f2894fa80f245/botocore-1.4.93.tar.gz"
    sha256 "3954b0c3bf67473181e9f6e3347154ba8ac6e66fab9bc07a25bb9e4e165d9726"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/ea/a6/6da0bac3ea8abbc2763fd2664af2955702f97f140f2d7277069445532b7c/celery-3.1.23.tar.gz"
    sha256 "1a359c815837f9dbf193a7dbc6addafa34612c077ff70c66e3b16e14eebd2418"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/82/f7/d6dfd7595910a20a563a83a762bf79a253c4df71759c3b228accb3d7e5e4/cryptography-1.7.1.tar.gz"
    sha256 "953fef7d40a49a795f4d955c5ce4338abcec5dea822ed0414ed30348303fdb4c"
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
    url "https://files.pythonhosted.org/packages/54/dd/17dc7e899ac7c1de2d19b367b29d90fdb4cfe83bda8c2581464906c9399d/gevent-1.2.1.tar.gz"
    sha256 "3de300d0e32c31311e426e4d5d73b36777ed99c2bac3f8fbad939eeb2c29fa7c"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/be/76/82af375d98724054b7e273b5d9369346937324f9bcc20980b45b068ef0b0/greenlet-0.4.12.tar.gz"
    sha256 "e4c99c6010a5d153d481fdaf63b8a0782825c0721506d880403a3b9b82ae347e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/81/62/c32d933d487d9756f55782de85a70b90cd6827a59a3e330f6adada408241/idna-2.3.tar.gz"
    sha256 "fe077ccaefbcc84b1b1fe8fae9dc0c3b71079df4bf5398796ece0b84be9cbdc3"
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
    url "https://files.pythonhosted.org/packages/71/59/d7423bd5e7ddaf3a1ce299ab4490e9044e8dfd195420fc83a24de9e60726/Jinja2-2.9.5.tar.gz"
    sha256 "702a24d992f856fa8d5a7a36db6128198d0c21e1da34448ca236c42e92384825"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/9d/1a/c8ab901753ad7581032f99f88c759a45b6c72b75615f0cd731dd7c9dd0de/jmespath-0.9.1.tar.gz"
    sha256 "e72d02de23c1814322f7c0dcffb46716271f9b52b129aace0ab6f5a0450d5f02"
  end

  resource "kombu" do
    url "https://files.pythonhosted.org/packages/38/69/8d603be2df979f1b9ffefae1e51cde664c52a258aff6e8c3253032c8f2c8/kombu-3.0.37.tar.gz"
    sha256 "e064a00c66b4d1058cd2b0523fb8d98c82c18450244177b6c0f7913016642650"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c2/93/dbb41b03cf7c878a7409c8e92226531f840a423c9309ea534873a83c9192/networkx-1.11.tar.gz"
    sha256 "0d0e70e10dfb47601cbb3425a00e03e2a2e97477be6f80638fef91d54dd1e4b8"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/c8/bf/628855545eb7782be701ec1c51b2e84e0cf9325e36daa09fddab7894954f/openpyxl-2.2.0-b1.tar.gz"
    sha256 "3394d92810796164ae1b12bb58c91b332174769ed0df5b7396a81471b9ba2058"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/7b/a8/dc2d50a6f37c157459cd18bab381c8e6134b9381b50fbe969997b2ae7dbc/psycopg2-2.6.2.tar.gz"
    sha256 "70490e12ed9c5c818ecd85d185d363335cc8a8cbf7212e3c185431c79ff8c05c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/60/32/7703bccdba05998e4ff04db5038a6695a93bedc45dcf491724b85b5db76a/pyasn1-modules-0.0.8.tar.gz"
    sha256 "10561934f1829bcc455c7ecdcdacdb4be5ffd3696f26f468eb6eb41e107f3837"
  end

  resource "PyContracts" do
    url "https://files.pythonhosted.org/packages/05/cf/93c6bba08bf268063c13cd9ad7656c9ab12d15cd7d88a9abe38e7eb0c74e/PyContracts-1.7.15.tar.gz"
    sha256 "24bf3ab5cfd61d0e296af82fb8b73ba875ea09733a8ca562f53016cf980dc469"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"
    sha256 "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/75/c5/85d027471fa665f8c8b8eb0b925f9d84b4eee745a257b16de4957de99e81/python-dateutil-2.2.tar.gz"
    sha256 "eec865307ebe7f329a6a9945c15453265a449cdaaf3710340828a1934d53e468"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/d0/e1/aca6ef73a7bd322a7fc73fd99631ee3454d4fc67dc2bee463e2adf6bb3d3/pytz-2016.10.tar.bz2"
    sha256 "7016b2c4fa075c564b81c37a252a5fccf60d8964aa31b7f5eae59aeb594ae02b"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/45/ca/f0c2ca6c65084d60f68553cf072de7db0d918c7bb07ece88781f6af24625/pycryptodome-3.4.5.tar.gz"
    sha256 "be84544eadc2bb71d4ace39e4984ed2990111f053f24267a07afb4b4e1e5428f"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/68/44/5efe9e98ad83ef5b742ce62a15bea609ed5a0d1caf35b79257ddb324031a/redis-2.10.5.tar.gz"
    sha256 "5dfbae6acfc54edf0a7a415b99e0b21c0a3c27a7f787b292eea727b1facc5533"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
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
    url "https://files.pythonhosted.org/packages/d2/de/236598743200966fd60e40248d70f97d12ec101ca1ab3674a4fbbe724893/snowflake-connector-python-1.3.12.tar.gz"
    sha256 "55e6047aea9f6b392eeca327013979aa20524d055531ddc15873886c856e3398"
  end

  resource "snowplow-tracker" do
    url "https://files.pythonhosted.org/packages/6d/af/7fea9ae4876a830d70dd17a24e647dd472b3b9f1d1f1dae75a2d44042505/snowplow-tracker-0.7.2.tar.gz"
    sha256 "4eac1d5fe1e6d7d7d62fe4a780d9b5795c587ac1bf0430b1225bc744ab638268"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/24/de/66d96cbad7a91443af1399469e9aa0aec8a41669ba6d0faae8b8411ddb27/SQLAlchemy-1.1.6.tar.gz"
    sha256 "815924e3218d878ddd195d2f9f5bf3d2bb39fabaddb1ea27dace6ac27d9865e4"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/9c/cc/3d8d34cfd0507dd3c278575e42baff2316a92513de0a87ac0ec9f32806c9/sqlparse-0.1.19.tar.gz"
    sha256 "d896be1a1c7f24bffe08d7a64e6f0176b260e281c5f3685afe7826f8bada4ee8"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/e6/5d/2b9ed56f2e69fe54cf00d07b7b3b9b43e8c9763dff3015365bd4c3f6f2a6/voluptuous-0.9.3.tar.gz"
    sha256 "ed5a11fda273754caabb6becd5fe172ee2621cd2c8ff8279433173bb7b0ec568"
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
    system "#{bin}/dbt", "compile"
  end
end
