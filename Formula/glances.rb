class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v3.1.3.tar.gz"
  sha256 "e3e8f9362b82c74427522e82501b47696945251035b35282f9ee4bc533996220"

  bottle do
    cellar :any_skip_relocation
    sha256 "10aa3df6da1e0df23a0fb20a12989bbec9c991ddf45cd2c9784771c57f4eba89" => :catalina
    sha256 "f7f572e6f31858bf69d72c9272fb8b77c6dbccaed1cd2d0834ad782e259e44f5" => :mojave
    sha256 "d87e75de7f80781c4bb44152f32c5757ab3528f6ad431fe31245e4107773d3f6" => :high_sierra
    sha256 "4ea6dd2e0cb8acf84e558c1f85eeed91f4fafd0eb5ead4c0945033ac4f37cf78" => :sierra
  end

  depends_on "python"

  resource "bernhard" do
    url "https://files.pythonhosted.org/packages/51/d4/b2701097f9062321262c4d4e3488fdf127887502b2619e8fd1ae13955a36/bernhard-0.2.6.tar.gz"
    sha256 "7efafa3ae1221a465fcbd74c4f78e5ad4a1841b9fa70c95eb38ba103a71bdb9b"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/c4/a5/6bf41779860e9b526772e1b3b31a65a22bd97535572988d16028c5ab617d/bottle-0.12.17.tar.gz"
    sha256 "e9eaa412a60cc3d42ceb42f58d15864d9ed1b92e9d630b8130c871c5bb16107c"
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/1c/fe/e4df42a3e864b6b7b2c7f6050b66cafc7fba8b46da0dfb9d51867e171a77/cassandra-driver-3.19.0.tar.gz"
    sha256 "a97271736cb5de8496c91b5e1195e2641866dfbc14d594708e49b0d4f4f7c9ef"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c5/67/5d0548226bcc34468e23a0333978f0e23d28d0b3f0c71a151aef9c3f7680/certifi-2019.6.16.tar.gz"
    sha256 "945e3ba63a0b9f577b1395204e13c3a231f9bc0223888be653286534e5873695"
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
    url "https://files.pythonhosted.org/packages/6a/81/425eb2011e53b20e5245489ff02f27d434b165746831daf26f755402fa6c/docker-4.0.2.tar.gz"
    sha256 "cc5b2e94af6a2b1e1ed9d7dcbdc77eff56c36081757baf9ada6e878ea0213164"
  end

  resource "elasticsearch" do
    url "https://files.pythonhosted.org/packages/d9/df/e18cab31af03e4b692d5cd49721d1aba26b07192829a3f8be6a511e75df2/elasticsearch-7.0.4.tar.gz"
    sha256 "d9eda8d9696f55d7d394ade625a262985d7af762c0b9305b73d421dace41c4e7"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/90/52/e20466b85000a181e1e144fd8305caf2cf475e2f9674e797b222f8105f5f/future-0.17.1.tar.gz"
    sha256 "67045236dcfd6816dc439556d009594abf643e5eb48992e36beac09c2ca659b8"
  end

  resource "Glances" do
    url "https://files.pythonhosted.org/packages/99/db/46c306997e4fc220f967716124fe6200ae88f0a82b9ce386886cb720d146/Glances-3.1.2.tar.gz"
    sha256 "733a30ee580d062759640a3ce9d7f5798b80c24e6dbf8f96269227bed7256894"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
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
    url "https://files.pythonhosted.org/packages/26/de/81a65219f7a3f3b2f53b693edec7fb1933f1d7b68b49c931d810d6317f5e/kafka-python-1.4.6.tar.gz"
    sha256 "08f83d8e0af2e64d25f94314d4bef6785b34e3b0df0effe9eebf76b98de66eeb"
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
    url "https://files.pythonhosted.org/packages/25/63/db25e62979c2a716a74950c9ed658dce431b5cb01fde29eb6cba9489a904/paho-mqtt-1.4.0.tar.gz"
    sha256 "e440a052b46d222e184be3be38676378722072fcd4dfd2c8f509fb861a7b0b79"
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
    url "https://files.pythonhosted.org/packages/6d/54/12c5c92ffab546538ea5b544c6afbfcce333fd47e99c1198e24a8efdef1f/protobuf-3.9.1.tar.gz"
    sha256 "d831b047bd69becaf64019a47179eb22118a50dd008340655266a906c69c6417"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1c/ca/5b8c1fe032a458c2c4bcbe509d1401dca9dda35c7fc46b36bb81c2834740/psutil-5.6.3.tar.gz"
    sha256 "863a85c1c0a5103a12c05a35e59d336e1d665747e531256e061213e2e90f63f3"
  end

  resource "py-cpuinfo" do
    url "https://files.pythonhosted.org/packages/42/60/63f28a5401da733043abe7053e7d9591491b4784c4f87c339bf51215aa0a/py-cpuinfo-5.0.0.tar.gz"
    sha256 "2cf6426f776625b21d1db8397d3297ef7acfa59018f02a8779123f3190f18500"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/e3/12/dfffc84b783e280e942409d6b651fe4a5a746433c34589da7362db2c99c6/pyasn1-0.4.6.tar.gz"
    sha256 "b773d5c9196ffbc3a1e13bdf909d446cad80a039aa3340bcad72f395b76ebc86"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/e4/90/a01cafbbad7466491e3a630bf1d734294a32ff1b10e7429e9a4e8478669e/pycryptodomex-3.9.0.tar.gz"
    sha256 "8b604f4fa1de456d6d19771b01c2823675a75a2c60e51a6b738f71fdfe865370"
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
    url "https://files.pythonhosted.org/packages/95/e4/f4c4da5d54e984a28a26dae1cbf6695e154cfd0dbc420d7f8d12b1e62719/pysnmp-4.4.11.tar.gz"
    sha256 "fe8bde566baea42e467ad55db028935cb3ac7243733b58ba25b1aa5b08f8fbec"
  end

  resource "pystache" do
    url "https://files.pythonhosted.org/packages/d6/fd/eb8c212053addd941cc90baac307c00ac246ac3fce7166b86434c6eae963/pystache-0.5.4.tar.gz"
    sha256 "f7bbc265fb957b4d6c7c042b336563179444ab313fb93a719759111eabd3b85a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/27/c0/fbd352ca76050952a03db776d241959d5a2ee1abddfeb9e2a53fdb489be4/pytz-2019.2.tar.gz"
    sha256 "26c0b32e437e54a18161324a2fca3c4b9846b74a8dccddd843113109e1116b32"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/7a/d2/1eb3a994374802b352d4911f3317313a5b4ea786bc830cc5e343dad9b06d/pyzmq-18.1.0.tar.gz"
    sha256 "93f44739db69234c013a16990e43db1aa0af3cf5a4b8b377d028ff24515fbeb3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "scandir" do
    url "https://files.pythonhosted.org/packages/df/f5/9c052db7bd54d0cbf1bc0bb6554362bba1012d03e5888950a4f5c5dadc4e/scandir-1.10.0.tar.gz"
    sha256 "4d4631f6062e658e9007ab3149a9b914f3548cb38bfb021c64f39a025ce578ae"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "statsd" do
    url "https://files.pythonhosted.org/packages/2d/f2/48ffc8d0051849e4417e809dc9420e76084c8a62749b3442915402127caa/statsd-3.3.0.tar.gz"
    sha256 "e3e6db4c246f7c59003e51c9720a51a7f39a396541cb9b147ff4b14d15b5dd1f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4c/13/2386233f7ee40aa8444b47f7463338f3cbdf00c316627558784e3f542f07/urllib3-1.25.3.tar.gz"
    sha256 "dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232"
  end

  resource "websocket_client" do
    url "https://files.pythonhosted.org/packages/c5/01/8c9c7de6c46f88e70b5a3276c791a2be82ae83d8e0d0cc030525ee2866fd/websocket_client-0.56.0.tar.gz"
    sha256 "1fd5520878b68b84b5748bb30e592b10d0a91529d5383f74f4964e72b297fd3a"
  end

  resource "wifi" do
    url "https://files.pythonhosted.org/packages/fe/a9/d026afe8a400dd40122385cd690e4fff4d574ed16f5c3a0f5e3921bfd383/wifi-0.3.8.tar.gz"
    sha256 "a9880b2e91ea8420154c6826c8112a2f541bbae5641d59c5cb031d27138d7f26"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/d7/25/8bbdd4857820e0cdc380c7e0c3543dc01a55247a1d831c712571783e74ec/zeroconf-0.23.0.tar.gz"
    sha256 "e0c333b967c48f8b2e5cc94a1d4d28893023fb06dfd797ee384a94cdd1d0eef5"
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
    begin
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
end
