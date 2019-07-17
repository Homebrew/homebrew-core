class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v3.1.1.tar.gz"
  sha256 "2fd826d39ed77bcc3656dfff15b4cb3613de9caae0f8e26bd578913110e189fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "c941b040718064941bf27dc9345b3d9c26480b5d1588ecdbc450cd9be5dc1c6b" => :mojave
    sha256 "b115bd28de608dc0c61b58eeb95e7ae319402f7d100d7794fd504f80b2770ab8" => :high_sierra
    sha256 "65abe69600074d65c68a517a397098201a407a7aa72ca1e0b4419675339550c5" => :sierra
  end

  depends_on "python"

  resource "bernhard" do
    url "https://files.pythonhosted.org/packages/51/d4/b2701097f9062321262c4d4e3488fdf127887502b2619e8fd1ae13955a36/bernhard-0.2.6.tar.gz"
    sha256 "7efafa3ae1221a465fcbd74c4f78e5ad4a1841b9fa70c95eb38ba103a71bdb9b"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/32/4e/ed046324d5ec980c252987c1dca191e001b9f06ceffaebf037eef469937c/bottle-0.12.16.tar.gz"
    sha256 "9c310da61e7df2b6ac257d8a90811899ccb3a9743e77e947101072a2e3186726"
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/28/1b/9edce1aaac85e7955e5a4eef2674294107640cc6cd5b7831926fc43a41b8/cassandra-driver-3.17.0.tar.gz"
    sha256 "6d42e11fd5879f12b1600e4c0f604e4432f472d030e80176b833c99c9cf989fc"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/b8/d1ea38513c22e8c906275d135818fee16ad8495985956a9b7e2bb21942a1/certifi-2019.3.9.tar.gz"
    sha256 "b26104d6835d1f5e49452a26eb2ff87fe7090b89dfcaee5ea2212697e1e1d7ae"
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
    url "https://files.pythonhosted.org/packages/4b/79/4206ea568bd0d134cd7cb6022dd60bea06ffdb8b5564288ca428fd3aeb0d/docker-3.7.2.tar.gz"
    sha256 "c456ded5420af5860441219ff8e51cdec531d65f4a9e948ccd4133e063b72f50"
  end

  resource "docker-pycreds" do
    url "https://files.pythonhosted.org/packages/c5/e6/d1f6c00b7221e2d7c4b470132c931325c8b22c51ca62417e300f5ce16009/docker-pycreds-0.4.0.tar.gz"
    sha256 "6ce3270bcaf404cc4c3e27e4b6c70d3521deae82fb508767870fdbf772d584d4"
  end

  resource "elasticsearch" do
    url "https://files.pythonhosted.org/packages/25/77/b832ef9e90664d9462fcb10b2840ba86e20a9399f3e7fcc2c8ab5d6c2220/elasticsearch-7.0.0.tar.gz"
    sha256 "cf6cf834b6d0172dac5e704c398a11d1917cf61f15d32b79b1ddad4cd673c4b1"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/90/52/e20466b85000a181e1e144fd8305caf2cf475e2f9674e797b222f8105f5f/future-0.17.1.tar.gz"
    sha256 "67045236dcfd6816dc439556d009594abf643e5eb48992e36beac09c2ca659b8"
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
    url "https://files.pythonhosted.org/packages/03/5e/d528d463bca6ff7fb9441df22d65890e39ebbb503e550c1030eef0863e52/influxdb-5.2.2.tar.gz"
    sha256 "afeff28953a91b4ea1aebf9b5b8258a4488d0e49e2471db15ea43fd2c8533143"
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
    url "https://files.pythonhosted.org/packages/ca/82/bb0e6c255575cbd8f57a8bd47aa2f29a2aa24f1363408abccd0690a3a244/pika-1.0.1.tar.gz"
    sha256 "5ba83d3daffccb92788d24facdab62a3db6aa03b8a6d709b03dc792d35c0dfe8"
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
    url "https://files.pythonhosted.org/packages/4c/bd/b42db3ec90ffc6be805aad09c1cea4bb13a620d0cd4b21aaa44d13541d71/prometheus_client-0.6.0.tar.gz"
    sha256 "1b38b958750f66f208bcd9ab92a633c0c994d8859c831f7abc1f46724fcee490"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/cf/72/8c1ed9148ded82adbb76c30f958c6d456a2abc08f092b62a586bdf973b80/protobuf-3.7.1.tar.gz"
    sha256 "21e395d7959551e759d604940a115c51c6347d90a475c9baf471a1a86b5604a9"
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
    url "https://files.pythonhosted.org/packages/46/60/b7e32f6ff481b8a1f6c8f02b0fd9b693d1c92ddd2efb038ec050d99a7245/pyasn1-0.4.5.tar.gz"
    sha256 "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/05/86/92b303bc4ed00451401e99e90003d5361fb054b9af9af2490b1b44caeaef/pycryptodomex-3.8.1.tar.gz"
    sha256 "9251b3f6254d4274caa21b79bd432bf07afa3567c6f02f11861659fb6245139a"
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
    url "https://files.pythonhosted.org/packages/37/0b/881859e98e05fefee3625637a1e87cb2ba8c550613c5ccb29910ad0efe66/pysnmp-4.4.9.tar.gz"
    sha256 "d5d1e59780126e963dd92e25993b783295734e71bef181f602e51f7393260441"
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
    url "https://files.pythonhosted.org/packages/df/d5/3e3ff673e8f3096921b3f1b79ce04b832e0100b4741573154b72b756a681/pytz-2019.1.tar.gz"
    sha256 "d747dd3d23d77ef44c6a3526e274af6efeb0a6f1afd5a69ba4d5be4098c8e141"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/f8/48/5416696b9f2eacc7d1f9fe3a7187ad54d769e09585ec0b59c137ab5c7575/pyzmq-18.0.1.tar.gz"
    sha256 "8b319805f6f7c907b101c864c3ca6cefc9db8ce0791356f180b1b644c7347e4c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz"
    sha256 "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e"
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
    url "https://files.pythonhosted.org/packages/fd/fa/b21f4f03176463a6cccdb612a5ff71b927e5224e83483012747c12fc5d62/urllib3-1.24.2.tar.gz"
    sha256 "9a247273df709c4fedb38c711e44292304f73f39ab01beda9f6b9fc375669ac3"
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
    url "https://files.pythonhosted.org/packages/9a/a3/9e4bb6a8e5f807c1a817168c9985f9d3975725a71ae77eb47ce1db66ada7/zeroconf-0.21.3.tar.gz"
    sha256 "5b52dfdf4e665d98a17bf9aa50dea7a8c98e25f972d9c1d7660e2b978a1f5713"
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
        exec bin/"glances", "-q", "--export", "csv", "--export-csv", "/dev/stdout", :out => write
      end
      header = read.gets
      assert_match "timestamp", header
    ensure
      Process.kill("TERM", pid)
    end
  end
end
