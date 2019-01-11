class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v3.0.2.tar.gz"
  sha256 "76a793a8e0fbdce11ad7fb35000695fdb70750f937db41f820881692d5b0a29c"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "8f44395cc8877e4199d86a92dda5e5c7ccecccf1f2ff0e8bc1eee2fc181d9f50" => :mojave
    sha256 "151f9f55d7c93b65e2ba6c2e3f3c06532714454240a30ff7cb52b60106da7064" => :high_sierra
    sha256 "2add753cf4012a42947989d47dffce297f7cceac84a14c332bb1805766b0d22e" => :sierra
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
    url "https://files.pythonhosted.org/packages/31/07/2423f77878559593ef17175ef2e0372dc91994368b15c6a47fca40b416ea/cassandra-driver-3.16.0.tar.gz"
    sha256 "42bcb167a90da6604081872ef609a327a63273842da81120fc462de031155abe"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/55/54/3ce77783acba5979ce16674fc98b1920d00b01d337cfaaf5db22543505ed/certifi-2018.11.29.tar.gz"
    sha256 "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"
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
    url "https://files.pythonhosted.org/packages/42/e1/784ec7b36b9b1592055b4c6f36f9cebfc320427cf56b8a9051f613d343f7/docker-3.7.0.tar.gz"
    sha256 "2840ffb9dc3ef6d00876bde476690278ab13fa1f8ba9127ef855ac33d00c3152"
  end

  resource "elasticsearch" do
    url "https://files.pythonhosted.org/packages/9d/ce/c4664e8380e379a9402ecfbaf158e56396da90d520daba21cfa840e0eb71/elasticsearch-6.3.1.tar.gz"
    sha256 "aada5cfdc4a543c47098eb3aca6663848ef5d04b4324935ced441debc11ec98b"
  end

  resource "Glances" do
    url "https://files.pythonhosted.org/packages/59/32/3bc36a9198998a4d73d5b19b02e0a59cde96fa1d8dccce05015a9b1929b7/Glances-3.0.2.tar.gz"
    sha256 "5eca4da689e4e2f98a637b38c9b72549998ac9f15cedbfb16626d8709df6dd25"
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
    url "https://files.pythonhosted.org/packages/0a/a9/9dc769bf971ce8b1daf653a3c90339dbbd4d3c23fca57ac48ede26592b5d/influxdb-5.2.1.tar.gz"
    sha256 "75d96de25d0d4e9e66e155f64dc9dc2a48de74ac4e77e3a46ad881fba772e3b6"
  end

  resource "kafka-python" do
    url "https://files.pythonhosted.org/packages/92/43/a88add4e70f14b11c533dfa04df77a17b8c936bdc0b119c5ad151a010fa1/kafka-python-1.4.4.tar.gz"
    sha256 "2014bbbe618f3224e68b07cf9b44c702b28913c551e6f63246bf9b4477ca3add"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/0d/18/fd6e9c71a35b67a73160ec80a49da63d1eed2d2055054cc2995714949132/netifaces-0.10.9.tar.gz"
    sha256 "2dee9ffdd16292878336a58d04a20f0ffe95555465fee7c9bd23b3490ef2abf3"
  end

  resource "nvidia-ml-py3" do
    url "https://files.pythonhosted.org/packages/6d/64/cce82bddb80c0b0f5c703bbdafa94bfb69a1c5ad7a79cff00b482468f0d3/nvidia-ml-py3-7.352.0.tar.gz"
    sha256 "390f02919ee9d73fe63a98c73101061a6b37fa694a793abf56673320f1f51277"
  end

  resource "pika" do
    url "https://files.pythonhosted.org/packages/ac/a0/e9a0268094e0b569b03153fd11b9b9f54c4df8d7917c55550edbcdf8b55e/pika-0.12.0.tar.gz"
    sha256 "306145b8683e016d81aea996bcaefee648483fc5a9eb4694bb488f54df54a751"
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
    url "https://files.pythonhosted.org/packages/bc/e1/3cddac03c8992815519c5f50493097f6508fa153d067b494db8ab5e9c4ce/prometheus_client-0.5.0.tar.gz"
    sha256 "e8c11ff5ca53de6c3d91e1510500611cafd1d247a937ec6c588a0a7cc3bef93c"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/1b/90/f531329e628ff34aee79b0b9523196eb7b5b6b398f112bb0c03b24ab1973/protobuf-3.6.1.tar.gz"
    sha256 "1489b376b0f364bcc6f89519718c057eb191d7ad6f1b395ffd93d1aa45587811"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e3/58/0eae6e4466e5abf779d7e2b71fac7fba5f59e00ea36ddb3ed690419ccb0f/psutil-5.4.8.tar.gz"
    sha256 "6e265c8f3da00b015d24b842bfeb111f856b13d24f2c57036582568dc650d6c3"
  end

  resource "py-cpuinfo" do
    url "https://files.pythonhosted.org/packages/75/d0/7e547b0abfa23234c82100d1bfe670286a3361f4382fc766329f70bc34e8/py-cpuinfo-4.0.0.tar.gz"
    sha256 "6615d4527118d4ea1db4d86dac4340725b3906aa04bf36b7902f7af4425fb25f"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/46/60/b7e32f6ff481b8a1f6c8f02b0fd9b693d1c92ddd2efb038ec050d99a7245/pyasn1-0.4.5.tar.gz"
    sha256 "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/4c/09/7276a3481d9361dfa6e1530fc94f66cc66a3a651917b079925f176258d41/pycryptodomex-3.7.2.tar.gz"
    sha256 "5d4e10ad9ff7940da534119ef92a500dcf7c28351d15e12d74ef0ce025e37d5b"
  end

  resource "pygal" do
    url "https://files.pythonhosted.org/packages/14/52/2394f0f8444db3af299f2700aaff22f8cc3741fbd5ed644f782327d356b3/pygal-2.4.0.tar.gz"
    sha256 "9204f05380b02a8a32f9bf99d310b51aa2a932cba5b369f7a4dc3705f0a4ce83"
  end

  resource "pysmi" do
    url "https://files.pythonhosted.org/packages/71/32/182dd4fa0c4e20c2a14154d3133cc08374694c2518a7c5445a918332b113/pysmi-0.3.3.tar.gz"
    sha256 "4e35c2b935ba5a68e086d7781dae1b508c228a960279620d182e876448acf02f"
  end

  resource "pysnmp" do
    url "https://files.pythonhosted.org/packages/68/f3/b9e89e3efe9934156c36dd2bc0e1aed77e9716467d0082d236ec9c9a8b52/pysnmp-4.4.8.tar.gz"
    sha256 "13e6dcf7e10dc89f9d09df3eec87b2bc552bb450b64f724622d5149859c482b0"
  end

  resource "pystache" do
    url "https://files.pythonhosted.org/packages/d6/fd/eb8c212053addd941cc90baac307c00ac246ac3fce7166b86434c6eae963/pystache-0.5.4.tar.gz"
    sha256 "f7bbc265fb957b4d6c7c042b336563179444ab313fb93a719759111eabd3b85a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/01/68747933e8d12263d41ce08119620d9a7e5eb72c876a3442257f74490da0/python-dateutil-2.7.5.tar.gz"
    sha256 "88f9287c0174266bb0d8cedd395cfba9c58e87e5ad86b2ce58859bc11be3cf02"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/af/be/6c59e30e208a5f28da85751b93ec7b97e4612268bb054d0dff396e758a90/pytz-2018.9.tar.gz"
    sha256 "d5f05e487007e29e03409f9398d074e158d920d36eb82eaf66fb1136b0c5374c"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/b9/6a/bc9277b78f5c3236e36b8c16f4d2701a7fd4fa2eb697159d3e0a3a991573/pyzmq-17.1.2.tar.gz"
    sha256 "a72b82ac1910f2cf61a49139f4974f994984475f771b0faa730839607eeedddf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz"
    sha256 "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "statsd" do
    url "https://files.pythonhosted.org/packages/2d/f2/48ffc8d0051849e4417e809dc9420e76084c8a62749b3442915402127caa/statsd-3.3.0.tar.gz"
    sha256 "e3e6db4c246f7c59003e51c9720a51a7f39a396541cb9b147ff4b14d15b5dd1f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
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
