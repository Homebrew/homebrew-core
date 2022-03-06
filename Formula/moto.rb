class Moto < Formula
  include Language::Python::Virtualenv

  desc "Mock AWS services"
  homepage "http://getmoto.org/"
  url "https://files.pythonhosted.org/packages/c5/d0/6e42772040657ae8a88f05b95344315d1cd4774abfded68a03c3b8638737/moto-3.0.6.tar.gz"
  sha256 "53ab3b6647382f61ad5aef8351ccba3712fa9595b7826883e4a38a4ac5c9b5a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fc504b7104bdcdc7166d60ac1a98ff24040965b959048dac4683b300aa395293"
    sha256 cellar: :any,                 arm64_big_sur:  "4fd070b1a01c697c2d44924b5450568ddc80e30649be33fef1f6478925c1d8ec"
    sha256 cellar: :any,                 monterey:       "b21a1af03a730dc9e8277bfe7ea462d5849ea7decddc0123c25e864c8db9270e"
    sha256 cellar: :any,                 big_sur:        "61ac83c456ecb91a59f1c90f49a6582746daf7a68a0fe2c95c43fd4ad2300d4c"
    sha256 cellar: :any,                 catalina:       "ab69d7170e6588684d6bbb28c536c3196afa66f467b125df1d64d79dfd52b9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aeeaab0f80222c7edaeba5cebd2a7e60954eb69caa914c23f163c381de2b868"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/f2/76/2b5c76cc8ae4d3373a793059b2073af1bb5f37189532dacd4788d2d142d3/aws-sam-translator-1.42.0.tar.gz"
    sha256 "8a7976c0ee2fca004a590e17d3551a49c8d8ba14ed0cb3674ea270d41d0dcd5b"
  end

  resource "aws-xray-sdk" do
    url "https://files.pythonhosted.org/packages/49/26/927206007f1ac57b0801046dc9baed8df9ccbdc7622b79bdaf0c193e8051/aws-xray-sdk-2.9.0.tar.gz"
    sha256 "b0cd972db218d4d8f7b53ad806fc6184626b924c4997ae58fc9f2a8cd1281568"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a4/1f/ab159d65cd9c4524945fe8ba776fd0bfa6b5325c5db7cb831f9ce4baee2f/boto3-1.21.13.tar.gz"
    sha256 "16fae86d0c4993fd5112128bb4622a879f02363bccd045153cc0bbd7722cc9a5"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d8/7c/31b6e0a0524dc4f92872cd4147f8a3ec80ef4ff7855feee443f89722430c/botocore-1.24.13.tar.gz"
    sha256 "46e51f56f1c5784e4245e036503635fa71b722775657b6e1acf21ec5b906974c"
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
    url "https://files.pythonhosted.org/packages/ba/82/70a44ade5615b8b0482b46535d4cbe76366f99c48a94c4fc6c1fccb7bf42/cfn-lint-0.58.2.tar.gz"
    sha256 "484484e0a849b4f5d621bc55b1af7b46104370a2c1629b49376ab8281787e9eb"
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
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
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
    url "https://files.pythonhosted.org/packages/82/00/89037083314067f1605233f6f30b94fdddc89d18e283b30b0c5be9e7f801/itsdangerous-2.1.0.tar.gz"
    sha256 "d848fcb8bc7d507c4546b448574e8a44fc4ea2ba84ebf8d783290d53e81992f5"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
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
    url "https://files.pythonhosted.org/packages/62/0f/52c009332fdadd484e898dc8f2acca0663c1031b3517070fd34ad9c1b64e/MarkupSafe-2.1.0.tar.gz"
    sha256 "80beaf63ddfbc64a0452b841d8036ca0611e049650e20afcb882f5d3c266d65f"
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
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
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
    url "https://files.pythonhosted.org/packages/03/a5/186653e51cb20fe3ac793403334d4d077fbb7bb18a9c5c2fce8304d5a2e2/responses-0.18.0.tar.gz"
    sha256 "380cad4c1c1dc942e5e8a8eaae0b4d4edf708f4f010db8b7bcfafad1fcd254ff"
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
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
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
    url "https://files.pythonhosted.org/packages/eb/f6/d81ccf43ac2a3c80ddb6647653ac8b53ce2d65796029369923be06b815b8/wrapt-1.13.3.tar.gz"
    sha256 "1fea9cd438686e6682271d36f3481a9f3636195578bab9ca3382e2f5f01fc185"
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
