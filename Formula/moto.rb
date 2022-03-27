class Moto < Formula
  include Language::Python::Virtualenv

  desc "Mock AWS services"
  homepage "http://getmoto.org/"
  url "https://files.pythonhosted.org/packages/01/53/dccd9e2a0bcf133d201d4c193803efb30e1f77fbd03950ed556a36cc5b75/moto-3.1.2.tar.gz"
  sha256 "b4497c885bceca2f8bfb4635accfd490b8af1adfdae20a27e0e2b1b7cc43d63e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0b785418ee562d36be3d75b2a6825fc6d60a8c36dc0a68f6960247e3ade1376c"
    sha256 cellar: :any,                 arm64_big_sur:  "02498d1117b0f9b25344c51e3243d82e2560711db9d65aa6d269e36b129ad0f2"
    sha256 cellar: :any,                 monterey:       "45f8dded21a55fc8de5dde93db652926e401e49080d336a94bcab8547b8e6358"
    sha256 cellar: :any,                 big_sur:        "865fe0a23190e85c01264a012ed278bf8ab8e0cd7b94bccd053a0d6ef0e6b577"
    sha256 cellar: :any,                 catalina:       "829f524e744918e00409f4841d89f4d6b3d530ef04be408a297adee6fdbcd50e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abf02dc6bb11898dcfd067a1e9fff7b4104ca3fa17ba83d3c5523fc832cb00b"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/40/85/f0eecd063a65de84f944c6a020ca3599b9d3c08efc9d856991bc76e20326/aws-sam-translator-1.43.0.tar.gz"
    sha256 "07820609c0de16ec9824aa8b482c48a217bd431f437bcd980a65e7e841626d5d"
  end

  resource "aws-xray-sdk" do
    url "https://files.pythonhosted.org/packages/49/26/927206007f1ac57b0801046dc9baed8df9ccbdc7622b79bdaf0c193e8051/aws-xray-sdk-2.9.0.tar.gz"
    sha256 "b0cd972db218d4d8f7b53ad806fc6184626b924c4997ae58fc9f2a8cd1281568"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/fb/31/97b628ed56a63164bced939fc353a70f83075d225038228b610c141c39a3/boto3-1.21.27.tar.gz"
    sha256 "ef41b9c7b6311d5152bdc78f7de56912c1ed265debf7da14133e1ad00246ad50"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/78/14/7ed89fcf90f4e52343106051ec587a903467461c12d8f9921dac99562c12/botocore-1.24.27.tar.gz"
    sha256 "2c11db4b94b4b9504d2782acb758d29a7e5cbdfaa826601f222ac9ddcf004dde"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/c4/d7/285de572a2581211d93e45a5123d6aca52fb53a56de4246f75bcf50cb816/cfn-lint-0.58.4.tar.gz"
    sha256 "37bcef7275e4f4c5680857ec715e180a155856ba882c463576e8058c2ae1be09"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/ab/d2/45ea0ee13c6cffac96c32ac36db0299932447a736660537ec31ec3a6d877/docker-5.0.3.tar.gz"
    sha256 "d916a26b62970e7c2f554110ed6af04c7ccff8e9f81ad17d0d40c75637e227fb"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/bf/3d/3d909532ad541651390bf1321e097404cbd39d1d89c2046f42a460220fb3/ecdsa-0.17.0.tar.gz"
    sha256 "b9f500bb439e4153d0330610f5d26baaf18d17b8ced1bc54410d189385ea68aa"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/84/9d/66347e6b3e2eb78647392d3969c23bdc2d8b2fdc32bd078c817c15cb81ad/Flask-2.0.3.tar.gz"
    sha256 "e1120c228ca2f553b470df4a5fa927ab66258467526069981b3eb0a91902687d"
  end

  resource "Flask-Cors" do
    url "https://files.pythonhosted.org/packages/cf/25/e3b2553d22ed542be807739556c69621ad2ab276ae8d5d2560f4ed20f652/Flask-Cors-3.0.10.tar.gz"
    sha256 "b60839393f3b84a0f3746f6cdca56c1ad7426aa738b70d6c61375857823181de"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/0c/15/0e13d80b86cca5c1bd1d311344f5d1eabe036e5a472a38f0048d68cce40d/graphql-core-3.2.0.tar.gz"
    sha256 "86e2a0be008bfde19ef78388de8a725a1d942a9190ca431c24a60837973803ce"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/89/e3/b36266381ae7a1310a653bb85f4f3658c462a69634fa9b2fef76252a50ed/Jinja2-3.1.1.tar.gz"
    sha256 "640bed4bb501cbd17194b3cace1dc2126f5b619cf068a726b98192a0fde74ae9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/06/7e/44686b986ef9ca6069db224651baaa8300b93af2a085a5b135997bf659b3/jmespath-1.0.0.tar.gz"
    sha256 "a490e280edd1f57d6de88636992d05b71e97d69a26a19f058ecf7d304474bf5e"
  end

  resource "jschema-to-python" do
    url "https://files.pythonhosted.org/packages/1d/7f/5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849/jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsondiff" do
    url "https://files.pythonhosted.org/packages/21/c6/57158093587de0ab578da6f27467e00b037d63b3538204fc27860d427144/jsondiff-1.3.1.tar.gz"
    sha256 "04cfaebd4a5e5738948ab615710dc3ee98efbdf851255fd3977c4c2ee59e7312"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/35/0e/fe3ce0869add0213a1b45eef746cafb79ca45255a60ec918630c159e3490/jsonpickle-2.1.0.tar.gz"
    sha256 "84684cfc5338a534173c8dd69809e40f2865d0be1f8a2b7af8465e5b968dcfa9"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/29/7f/e6b5930e6dd1f461ad412dfc40bc94e5235011f6bbf73cafa8074617c203/jsonpointer-2.2.tar.gz"
    sha256 "f09f8deecaaa5aea65b5eb4f67ca4e54e1a61f7a11c75085e360fe6feb6a48bf"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "junit-xml-2" do
    url "https://files.pythonhosted.org/packages/4d/f2/a99adf9deb57949b81ff8e113edf971da1840251794a6f4184d61faa5a65/junit-xml-2-1.9.tar.gz"
    sha256 "3b8d9635c5215f754c7807104f6493e3ea3bc9481e2d33db294560da3a1b00f7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/9e/9e/3d67df5d543ffd743f4ccb12c9c90929e4f48136e3062e15a6d971d91202/networkx-2.7.1.tar.gz"
    sha256 "d1194ba753e5eed07cdecd1d23c5cd7a3c772099bd8dbd2fea366788cf4de7ba"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/51/da/eb358ed53257a864bf9deafba25bc3d6b8d41b0db46da4e7317500b1c9a5/pbr-5.8.1.tar.gz"
    sha256 "66bc5a34912f408bb3925bf21231cb6f59206267b7f63f3503ef865c1a292e25"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-jose" do
    url "https://files.pythonhosted.org/packages/e4/19/b2c86504116dc5f0635d29f802da858404d77d930a25633d2e86a64a35b3/python-jose-3.3.0.tar.gz"
    sha256 "55779b5e6ad599c6336191246e95eb2293a9ddebd555f796a65f838f07e5d78a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/fa/e2/d9ca37e4ba43f98b0ec66c4b9d1d20ec9e30a08053dd70458b9257e3130b/responses-0.20.0.tar.gz"
    sha256 "644905bc4fb8a18fa37e3882b2ac05e610fe8c2f967d327eed669e314d94a541"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/8c/ee/4022542e0fed77dd6ddade38e1e4dea3299f873b7fd4e6d78319953b0f83/rsa-4.8.tar.gz"
    sha256 "5c6bd9dc7a543b7fe4304a631f8a8a3b674e2bbfc49c2ae96200cdbe55df6b17"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/7e/19/f82e4af435a19b28bdbfba63f338ea20a264f4df4beaf8f2ab9bfa34072b/s3transfer-0.5.2.tar.gz"
    sha256 "95c58c194ce657a5f4fb0b9e60a84968c808888aed628cd98ab8771fe1db98ed"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "sshpubkeys" do
    url "https://files.pythonhosted.org/packages/a3/b9/e5b76b4089007dcbe9a7e71b1976d3c0f27e7110a95a13daf9620856c220/sshpubkeys-3.3.1.tar.gz"
    sha256 "3020ed4f8c846849299370fbe98ff4157b0ccc1accec105e07cfa9ae4bb55064"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/8d/12/cd10d050f7714ccc675b486cdcbbaed54c782a5b77da2bb82e5c7b31fb40/websocket-client-1.3.1.tar.gz"
    sha256 "6278a75065395418283f887de7c3beafb3aa68dada5cacbe4b214e8d26da499b"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/6c/a8/60514fade2318e277453c9588545d0c335ea3ea6440ce5cdabfca7f73117/Werkzeug-2.0.3.tar.gz"
    sha256 "b863f8ff057c522164b6067c9e28b041161b4be5ba4d0daceeaa50a163822d3c"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c7/b4/3a937c7f8ee4751b38274c8542e02f42ebf3e080f1344c4a2aff6416630e/wrapt-1.14.0.tar.gz"
    sha256 "8323a43bd9c91f62bb7d4be74cc9ff10090e7ef820e27bfe8815c57e68261311"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"moto_server"]
    keep_alive true
    working_dir var
    log_path var/"log/moto.log"
    error_log_path var/"log/moto.log"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"moto_server", "--port=#{port}"
    end

    # keep trying to connect until the server is up
    curl_cmd = "curl --silent 127.0.0.1:#{port}/"
    ohai curl_cmd
    output = ""
    exitstatus = 7
    loop do
      sleep 1
      output = `#{curl_cmd}`
      exitstatus = $CHILD_STATUS.exitstatus
      break if exitstatus != 7  # CURLE_COULDNT_CONNECT
    end

    assert_equal exitstatus, 0
    expected_output = <<~EOS
      <ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01"><Owner><ID>bcaf1ffd86f41161ca5fb16fd081034f</ID><DisplayName>webfile</DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>
    EOS
    assert_equal expected_output.strip, output.strip
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
