class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v3.1.4.1.tar.gz"
  sha256 "0347a0b949451fd0022c0f22e54092fe526120a776af1f2bde1ea7ba61d6b792"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bc1dc122d7ed7542795ac6b390dea5e7645528439295d29f8f127148425b5c2" => :catalina
    sha256 "4f1c3d51bf77bb95586c81bdf5170f5fd2b53d544f06a311d9152c00f4abb038" => :mojave
    sha256 "27db703a8a6fd3decc1d96ebed0c0d991c41a74e5a25d1c708a843671be072fd" => :high_sierra
  end

  depends_on "python@3.8"

  resource "bernhard" do
    url "https://files.pythonhosted.org/packages/51/d4/b2701097f9062321262c4d4e3488fdf127887502b2619e8fd1ae13955a36/bernhard-0.2.6.tar.gz"
    sha256 "7efafa3ae1221a465fcbd74c4f78e5ad4a1841b9fa70c95eb38ba103a71bdb9b"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/d9/4f/57887a07944140dae0d039d8bc270c249fc7fc4a00744effd73ae2cde0a9/bottle-0.12.18.tar.gz"
    sha256 "0819b74b145a7def225c0e83b16a4d5711fde751cd92bae467a69efce720f69e"
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/19/bd/b522b200e8a7cc5ace859e9667308a3a302a23d6df09ae087ca2dfbf60c2/cassandra-driver-3.22.0.tar.gz"
    sha256 "df825ee4ebb7f7fa33ab028d673530184fe0ee41ea66b2f9ddd478db56145a31"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "CouchDB" do
    url "https://files.pythonhosted.org/packages/7c/c8/f94a107eca0c178e5d74c705dad1a5205c0f580840bd1b155cd8a258cb7c/CouchDB-1.2.tar.gz"
    sha256 "1386a1a43f25bed3667e3b805222054940d674fa1967fa48e9d2012a18630ab7"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/96/62/cd321bff4c55532e46f2824df8981fba9ac793d148d410bbdd4b8a98bd3c/docker-4.2.0.tar.gz"
    sha256 "ddae66620ab5f4bce769f64bcd7934f880c8abe6aa50986298db56735d0f722e"
  end

  resource "elasticsearch" do
    url "https://files.pythonhosted.org/packages/94/1a/2369fc9264c655c20908053b59fae7f65ddc47f123d89b533a724ae1d19d/elasticsearch-7.6.0.tar.gz"
    sha256 "d228b2d37ac0865f7631335268172dbdaa426adec1da3ed006dddf05134f89c8"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "Glances" do
    url "https://files.pythonhosted.org/packages/05/a6/420f3bd9add62f7da69bc43033610bcecbd344363a926b8093245f5b9779/Glances-3.1.4.1.tar.gz"
    sha256 "22bdaae4ff194516e35d068729ee72aeab506b3d561c2974ddbf58f2f64392b3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/9f/54/d92bda685093ebc70e2057abfa83ef1b3fb0ae2b6357262a3e19dfe96bb8/ifaddr-0.1.6.tar.gz"
    sha256 "c19c64882a7ad51a394451dabcbbed72e98b5625ec1e79789924d5ea3e3ecb93"
  end

  resource "influxdb" do
    url "https://files.pythonhosted.org/packages/d2/0d/351a346886ecbe61211cbfcad8ac73f99f5a9bf526916631c5668dbad601/influxdb-5.2.3.tar.gz"
    sha256 "30276c7e04bf7659424c733b239ba2f0804d7a1f3c59ec5dd3f88c56176c8d36"
  end

  resource "kafka-python" do
    url "https://files.pythonhosted.org/packages/8c/5d/2eda2648fbd9a024721b4d551eb671091a03b564455fe2ad5c643b6b06c3/kafka-python-2.0.1.tar.gz"
    sha256 "e59ad42dec8c7d54e3fbba0c1f8b54c44d92a3392d88242962d0c29803f2f6f8"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/0d/18/fd6e9c71a35b67a73160ec80a49da63d1eed2d2055054cc2995714949132/netifaces-0.10.9.tar.gz"
    sha256 "2dee9ffdd16292878336a58d04a20f0ffe95555465fee7c9bd23b3490ef2abf3"
  end

  resource "nvidia-ml-py3" do
    url "https://files.pythonhosted.org/packages/6d/64/cce82bddb80c0b0f5c703bbdafa94bfb69a1c5ad7a79cff00b482468f0d3/nvidia-ml-py3-7.352.0.tar.gz"
    sha256 "390f02919ee9d73fe63a98c73101061a6b37fa694a793abf56673320f1f51277"
  end

  resource "paho-mqtt" do
    url "https://files.pythonhosted.org/packages/59/11/1dd5c70f0f27a88a3a05772cd95f6087ac479fac66d9c7752ee5e16ddbbc/paho-mqtt-1.5.0.tar.gz"
    sha256 "e3d286198baaea195c8b3bc221941d25a3ab0e1507fc1779bdb7473806394be4"
  end

  resource "pbkdf2" do
    url "https://files.pythonhosted.org/packages/02/c0/6a2376ae81beb82eda645a091684c0b0becb86b972def7849ea9066e3d5e/pbkdf2-1.3.tar.gz"
    sha256 "ac6397369f128212c43064a2b4878038dab78dab41875364554aaf2a684e6979"
  end

  resource "pika" do
    url "https://files.pythonhosted.org/packages/8c/6d/a526ad96ffb8aa0d3ab7e8660eb1c9fc964a02e7624112d70e4b63fb2bb7/pika-1.1.0.tar.gz"
    sha256 "9fa76ba4b65034b878b2b8de90ff8660a59d925b087c5bb88f8fdbb4b64a1dbf"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "potsdb" do
    url "https://files.pythonhosted.org/packages/14/dd/c7c618f87cb6005adf86eafa08e33f2e807dbd2128d992e53d5ee1a87cbc/potsdb-1.0.3.tar.gz"
    sha256 "ef8317e45758552c6fe15a5246f93afee6f40c1c7e08dc0469e70adf463ed447"
  end

  resource "prometheus_client" do
    url "https://files.pythonhosted.org/packages/b3/23/41a5a24b502d35a4ad50a5bb7202a5e1d9a0364d0c12f56db3dbf7aca76d/prometheus_client-0.7.1.tar.gz"
    sha256 "71cd24a2b3eb335cb800c7159f423df1bd4dcd5171b234be15e3f31ec9f622da"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c9/d5/e6e789e50e478463a84bd1cdb45aa408d49a2e1aaffc45da43d10722c007/protobuf-3.11.3.tar.gz"
    sha256 "c77c974d1dadf246d789f6dad1c24426137c9091e930dbf50e0a29c1fcf00b1f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/c4/b8/3512f0e93e0db23a71d82485ba256071ebef99b227351f0f5540f744af41/psutil-5.7.0.tar.gz"
    sha256 "685ec16ca14d079455892f25bd124df26ff9137664af445563c1bd36629b5e0e"
  end

  resource "py-cpuinfo" do
    url "https://files.pythonhosted.org/packages/42/60/63f28a5401da733043abe7053e7d9591491b4784c4f87c339bf51215aa0a/py-cpuinfo-5.0.0.tar.gz"
    sha256 "2cf6426f776625b21d1db8397d3297ef7acfa59018f02a8779123f3190f18500"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/7f/3c/80cfaec41c3a9d0f524fe29bca9ab22d02ac84b5bfd6e22ade97d405bdba/pycryptodomex-3.9.7.tar.gz"
    sha256 "50163324834edd0c9ce3e4512ded3e221c969086e10fdd5d3fdcaadac5e24a78"
  end

  resource "pygal" do
    url "https://files.pythonhosted.org/packages/14/52/2394f0f8444db3af299f2700aaff22f8cc3741fbd5ed644f782327d356b3/pygal-2.4.0.tar.gz"
    sha256 "9204f05380b02a8a32f9bf99d310b51aa2a932cba5b369f7a4dc3705f0a4ce83"
  end

  resource "pymdstat" do
    url "https://files.pythonhosted.org/packages/23/70/6e033dd42b832ca79c81f291460f1039e236a389d9c29443692b577c0073/pymdstat-0.4.2.tar.gz"
    sha256 "fef53c6f1864fdfe8616d6e985498b7f05ef19d0952f7ec3e7f8379298b9ada9"
  end

  resource "pysmi" do
    url "https://files.pythonhosted.org/packages/52/42/ddaeb06ff551672b17b77f81bc2e26b7c6060b28fe1552226edc6476ce37/pysmi-0.3.4.tar.gz"
    sha256 "bd15a15020aee8376cab5be264c26330824a8b8164ed0195bd402dd59e4e8f7c"
  end

  resource "pysnmp" do
    url "https://files.pythonhosted.org/packages/4e/75/72f64c451bf5884715f84f8217b69b4025da0b67628d611cd14a5b7db217/pysnmp-4.4.12.tar.gz"
    sha256 "0c3dbef2f958caca96071fe5c19de43e9c1b0484ab02a0cf08b190bcee768ba9"
  end

  resource "pystache" do
    url "https://files.pythonhosted.org/packages/d6/fd/eb8c212053addd941cc90baac307c00ac246ac3fce7166b86434c6eae963/pystache-0.5.4.tar.gz"
    sha256 "f7bbc265fb957b4d6c7c042b336563179444ab313fb93a719759111eabd3b85a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/82/c3/534ddba230bd4fbbd3b7a3d35f3341d014cca213f369a9940925e7e5f691/pytz-2019.3.tar.gz"
    sha256 "b02c06db6cf09c12dd25137e563b31700d3b80fcc4ad23abb7a315f2789819be"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/16/4c/762c2c3063c4d45baf4a49acea7a4f561f7b78a45cd04b58d63f4c5f6b8d/pyzmq-19.0.0.tar.gz"
    sha256 "5e1f65e576ab07aed83f444e201d86deb01cd27dcf3f37c727bc8729246a60a8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "scandir" do
    url "https://files.pythonhosted.org/packages/df/f5/9c052db7bd54d0cbf1bc0bb6554362bba1012d03e5888950a4f5c5dadc4e/scandir-1.10.0.tar.gz"
    sha256 "4d4631f6062e658e9007ab3149a9b914f3548cb38bfb021c64f39a025ce578ae"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "statsd" do
    url "https://files.pythonhosted.org/packages/2d/f2/48ffc8d0051849e4417e809dc9420e76084c8a62749b3442915402127caa/statsd-3.3.0.tar.gz"
    sha256 "e3e6db4c246f7c59003e51c9720a51a7f39a396541cb9b147ff4b14d15b5dd1f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/09/06/3bc5b100fe7e878d3dee8f807a4febff1a40c213d2783e3246edde1f3419/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
  end

  resource "websocket_client" do
    url "https://files.pythonhosted.org/packages/8b/0f/52de51b9b450ed52694208ab952d5af6ebbcbce7f166a48784095d930d8c/websocket_client-0.57.0.tar.gz"
    sha256 "d735b91d6d1692a6a181f2a8c9e0238e5f6373356f561bb9dc4c7af36f452010"
  end

  resource "wifi" do
    url "https://files.pythonhosted.org/packages/fe/a9/d026afe8a400dd40122385cd690e4fff4d574ed16f5c3a0f5e3921bfd383/wifi-0.3.8.tar.gz"
    sha256 "a9880b2e91ea8420154c6826c8112a2f541bbae5641d59c5cb031d27138d7f26"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/93/22/e6e46427412134baaabc8e8232861da1acf8a2e8067b46f3f9149b0805cb/zeroconf-0.24.5.tar.gz"
    sha256 "893a841445663e0c4c20d1111ce41484bd62d58f59d653d0485187343368ef4a"
  end

  resource "bernhard" do
    url "https://files.pythonhosted.org/packages/51/d4/b2701097f9062321262c4d4e3488fdf127887502b2619e8fd1ae13955a36/bernhard-0.2.6.tar.gz"
    sha256 "7efafa3ae1221a465fcbd74c4f78e5ad4a1841b9fa70c95eb38ba103a71bdb9b"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", :out => write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end
