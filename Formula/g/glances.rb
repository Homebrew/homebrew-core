class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/e0/df/96cd0ff650bd491a73815171131304d9c0d15d90ef44fed26324558aabf0/glances-4.3.1.tar.gz"
  sha256 "952c4985b9c1ff9d9ebd23760a2dd124fa2315cf02acfa68f3b7e1c51e087c8c"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37a41ae98dffda4f559f05f55d71d0086fd1a2ac613c006ee3ff3b6cb1e9ac71"
    sha256 cellar: :any,                 arm64_sonoma:  "aae20b66df0135a2f23b6a61566c0513cfd545cabc4db79417589aabf1af1924"
    sha256 cellar: :any,                 arm64_ventura: "d7fcbb651eca41a607261f4ffb2877c2d5ecb1e0111ecec4c4d1e0d86f52dd14"
    sha256 cellar: :any,                 sonoma:        "d3a0f2f5b659d8e3bb16fc9ff840daeca35dd26a49ad1bf3ffd4473f04d0d221"
    sha256 cellar: :any,                 ventura:       "e5dd307c41b7190a03383c883c3002ae99d7ee4fa849bafe2362aab49a4ea53f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b9feb3745aa87f7af6e2c63b3594af5ddb9810cf2a2f03716c42a39c2562f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a1fe10103dd128f84d43172f6e6980ad753ccdb8ee6f331e1432852ee2b5cb9"
  end

  depends_on "cmake" => :build # for pyzmq
  depends_on "rust" => :build # for orjson

  depends_on "certifi"
  depends_on "cffi"
  depends_on "cryptography"
  depends_on "pycparser"
  depends_on "python@3.13"
  depends_on "six"
  depends_on "zeromq"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "bernhard" do
    url "https://files.pythonhosted.org/packages/51/d4/b2701097f9062321262c4d4e3488fdf127887502b2619e8fd1ae13955a36/bernhard-0.2.6.tar.gz"
    sha256 "7efafa3ae1221a465fcbd74c4f78e5ad4a1841b9fa70c95eb38ba103a71bdb9b"
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/b2/6f/d25121afaa2ea0741d05d2e9921a7ca9b4ce71634b16a8aaee21bd7af818/cassandra-driver-3.29.2.tar.gz"
    sha256 "c4310a7d0457f51a63fb019d8ef501588c491141362b53097fbc62fa06559b7c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "elastic-transport" do
    url "https://files.pythonhosted.org/packages/6a/54/d498a766ac8fa475f931da85a154666cc81a70f8eb4a780bc8e4e934e9ac/elastic_transport-8.17.1.tar.gz"
    sha256 "5edef32ac864dca8e2f0a613ef63491ee8d6b8cfb52881fa7313ba9290cac6d2"
  end

  resource "elasticsearch" do
    url "https://files.pythonhosted.org/packages/39/58/0081e189ef83dd1f11cb600df842bffb8eaa05c097cb1672c5bd335b46c2/elasticsearch-9.0.1.tar.gz"
    sha256 "76f9b519cfd15a860f615a94ba90dcb9543b721306bc5144ecc15f0b4d5d2781"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/f4/55/ae499352d82338331ca1e28c7f4a63bfd09479b16395dce38cf50a39e2c2/fastapi-0.115.12.tar.gz"
    sha256 "1e2c2a2646905f9e83d32f04a3f86aff4a286669c6c950ca95b5fd68c2602681"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/cf/21/58251b3de99e0b5ba649ff511f7f9e8399c3059dd52a643774106e929afa/geomet-0.2.1.post1.tar.gz"
    sha256 "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95"
  end

  resource "graphitesender" do
    url "https://files.pythonhosted.org/packages/23/06/6250bb18e5f96f01d4995e980303ae4d71d8b120f972e9569733e14969cb/graphitesender-0.11.2.tar.gz"
    sha256 "578e93e32f67b6545498f82edd12298e5394c7d5e091dfcc152fb87e04e0b074"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "ibm-cloud-sdk-core" do
    url "https://files.pythonhosted.org/packages/ac/99/b126b89c3905dd85d0f35f20252c058999fd452a162566b05641f219e9ea/ibm_cloud_sdk_core-3.23.0.tar.gz"
    sha256 "393cb7c8e747d2706f495bc29ae54871979ab2f2e7cb907cd4d4d4f011a92d93"
  end

  resource "ibmcloudant" do
    url "https://files.pythonhosted.org/packages/be/12/20225ed23d654b09b0e4e174df567d57118c722e57b1d565e691728aad2b/ibmcloudant-0.10.2.tar.gz"
    sha256 "a48c809576ce851f55670e2b19289fee9189db32730d0be957cadac01f545a19"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "influxdb" do
    url "https://files.pythonhosted.org/packages/12/d4/4c1bd3a8f85403fad3137a7e44f7882b0366586b7c27d12713493516f1c7/influxdb-5.3.2.tar.gz"
    sha256 "58c647f6043712dd86e9aee12eb4ccfbbb5415467bc9910a48aa8c74c1108970"
  end

  resource "influxdb-client" do
    url "https://files.pythonhosted.org/packages/11/47/b756380917cb4b968bd871fc006128e2cc9897fb1ab4bcf7d108f9601e78/influxdb_client-1.48.0.tar.gz"
    sha256 "414d5b5eff7d2b6b453f33e2826ea9872ea04a11996ba9c8604b0c1df57c8559"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "kafka-python" do
    url "https://files.pythonhosted.org/packages/81/e1/e84f846614195c01c9e98db6e58bd18eaa7baaa01e78d95b0522d03e8c66/kafka_python-2.2.6.tar.gz"
    sha256 "b18a15e614864afedd514cc75f203cc3555bb85b915326c9fce0e49a80ca441f"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "netifaces2" do
    url "https://files.pythonhosted.org/packages/19/40/8818b20a921c39fc6d6a508f180b9ae97e35b90a8d8b91d64db54f625225/netifaces2-0.0.22.tar.gz"
    sha256 "c872a54e1a0e2bf078593b4460013996de804e40cab1b0ebc377b0e74b52a244"
  end

  resource "nvidia-ml-py" do
    url "https://files.pythonhosted.org/packages/d2/4d/6f017814ed5ac28e08e1b8a62e3a258957da27582c89b7f8f8b15ac3d2e7/nvidia_ml_py-12.575.51.tar.gz"
    sha256 "6490e93fea99eb4e966327ae18c6eec6256194c921f23459c8767aee28c54581"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paho-mqtt" do
    url "https://files.pythonhosted.org/packages/39/15/0a6214e76d4d32e7f663b109cf71fb22561c2be0f701d67f93950cd40542/paho_mqtt-2.1.0.tar.gz"
    sha256 "12d6e7511d4137555a3f6ea167ae846af2c7357b10bc6fa4f7c3968fc1723834"
  end

  resource "pbkdf2" do
    url "https://files.pythonhosted.org/packages/02/c0/6a2376ae81beb82eda645a091684c0b0becb86b972def7849ea9066e3d5e/pbkdf2-1.3.tar.gz"
    sha256 "ac6397369f128212c43064a2b4878038dab78dab41875364554aaf2a684e6979"
  end

  resource "pika" do
    url "https://files.pythonhosted.org/packages/db/db/d4102f356af18f316c67f2cead8ece307f731dd63140e2c71f170ddacf9b/pika-1.3.2.tar.gz"
    sha256 "b2a327ddddf8570b4965b3576ac77091b850262d34ce8c1d8cb4e4146aa4145f"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "podman" do
    url "https://files.pythonhosted.org/packages/fa/5c/ff701e438360a526a728eae3c18ee439c0875e4b937947f1cd04497ae17e/podman-5.4.0.1.tar.gz"
    sha256 "ee537aaa44ba530fad7cd939d886a7632f9f7018064e7831e8cb614c54cb1789"
  end

  resource "potsdb" do
    url "https://files.pythonhosted.org/packages/14/dd/c7c618f87cb6005adf86eafa08e33f2e807dbd2128d992e53d5ee1a87cbc/potsdb-1.0.3.tar.gz"
    sha256 "ef8317e45758552c6fe15a5246f93afee6f40c1c7e08dc0469e70adf463ed447"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/62/14/7d0f567991f3a9af8d1cd4f619040c93b68f09a02b6d0b6ab1b2d1ded5fe/prometheus_client-0.21.1.tar.gz"
    sha256 "252505a722ac04b0456be05c05f75f45d760c2911ffc45f2a06bcaed9f3ae3fb"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c8/8c/cf2ac658216eebe49eaedf1e06bc06cbf6a143469236294a1171a51357c3/protobuf-6.30.2.tar.gz"
    sha256 "35c859ae076d8c56054c25b59e5e59638d86545ed6e2b6efac6be0b6ea3ba048"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/77/ab/5250d56ad03884ab5efd07f734203943c8a8ab40d551e208af81d0257bf2/pydantic-2.11.4.tar.gz"
    sha256 "32738d19d63a226a52eed76645a98ee07c1f410ee41d93b4afbfa85ed8111c2d"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygal" do
    url "https://files.pythonhosted.org/packages/49/7b/8f50821a0f1585881ef40ae13ecb7603b0d81ef99fedf992ec35e6b6f7d5/pygal-3.0.5.tar.gz"
    sha256 "c0a0f34e5bc1c01975c2bfb8342ad521e293ad42e525699dd00c4d7a52c14b71"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pymdstat" do
    url "https://files.pythonhosted.org/packages/86/ee/bb7efa8ef03a35be5072494b4813d5e2d31fd29d8f106b7f73947744d702/pymdstat-0.4.3.tar.gz"
    sha256 "606f5032aad67c5f096fdc1c56cbe9beba80f5c1aa544c6b82a3e12c8f9105f1"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/85/27/3634b2e8d88ad210ee6edac69259c698aefed4a79f0f7356cd625d5c423c/pymongo-4.12.1.tar.gz"
    sha256 "8921bac7f98cccb593d76c4d8eaa1447e7d537ba9a2a202973e92372a05bd1eb"
  end

  resource "pysmart-smartx" do
    url "https://files.pythonhosted.org/packages/77/91/d23dba85d98e548fdde744217fd8fbad2bb9b89843ac73fbfcf45b102d5b/pySMART.smartx-0.3.10.tar.gz"
    sha256 "f907d9b91ad934d9b53337e95764bca8c2305ef8e1c4e6669c77faf1f1cf9099"
  end

  resource "pysmi-lextudio" do
    url "https://files.pythonhosted.org/packages/c8/0c/bec628167236bfea4bdf780f573f9c16f8977d1fe1e9123100abb1e7b683/pysmi_lextudio-1.4.3.tar.gz"
    sha256 "7d255fb38669410835acf6c2e8ab41975a6d8e64593b119552e36ecba004054f"
  end

  resource "pysnmp-lextudio" do
    url "https://files.pythonhosted.org/packages/62/60/37574e7cd70d686a9b2167dd2baff814f04aa36b2fb94acc1dcc0320357b/pysnmp_lextudio-6.1.2.tar.gz"
    sha256 "4035677d236f9fb6da5dbcfae2dc9122ee3652f535efeb904a56f54f162f28c9"
  end

  resource "pysnmpcrypto" do
    url "https://files.pythonhosted.org/packages/3e/87/86a32362944ea2d554dce797f3988e9a9bdd24447b906c99d44d1f70506a/pysnmpcrypto-0.0.4.tar.gz"
    sha256 "b635fb3b1ec6637b9a0033f50506214e16eb84574b1d25ab027bbde4caa55129"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/b1/11/b9213d25230ac18a71b39b3723494e57adebe36e066397b961657b3b41c1/pyzmq-26.4.0.tar.gz"
    sha256 "4bd13f85f80962f91a651a7356fe0472791a5f7a92f227822b5acf44795c626d"
  end

  resource "reactivex" do
    url "https://files.pythonhosted.org/packages/ef/63/f776322df4d7b456446eff78c4e64f14c3c26d57d46b4e06c18807d5d99c/reactivex-4.0.4.tar.gz"
    sha256 "e912e6591022ab9176df8348a653fe8c8fa7a301f26f9931c9d8c78a650e04e8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/95/32/0cc40fe41fd2adb80a2f388987f4f8db3c866c69e33e0b4c8b093fdf700e/setuptools-80.4.0.tar.gz"
    sha256 "5a78f61820bc088c8e4add52932ae6b8cf423da2aff268c23f813cfbb13b4006"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sparklines" do
    url "https://files.pythonhosted.org/packages/42/10/a55ffb7b5ae130804ebcb53ecbb711a902403fe7efe67739aceeb4daf8f5/sparklines-0.5.0.tar.gz"
    sha256 "069e48633fc1af354e9bbdfd0a644c1279d6632a572446aa9d741105f1177000"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/ce/20/08dfcd9c983f6a6f4a1000d934b9e6d626cff8d2eeb77a89a68eef20a2b7/starlette-0.46.2.tar.gz"
    sha256 "7f7361f34eed179294600af672f565727419830b54b7b084efe44bb82d2fccd5"
  end

  resource "statsd" do
    url "https://files.pythonhosted.org/packages/27/29/05e9f50946f4cf2ed182726c60d9c0ae523bb3f180588c574dd9746de557/statsd-4.0.1.tar.gz"
    sha256 "99763da81bfea8daf6b3d22d11aaccb01a8d0f52ea521daab37e758a4ca7d128"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/82/5c/e6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82/typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/a6/ae/9bbb19b9e1c450cf9ecaef06463e40234d98d95bf572fab11b4f19ae5ded/uvicorn-0.34.2.tar.gz"
    sha256 "0e929828f6186353a80b58ea719861d2629d766293b6d19baf086ba31d4f3328"
  end

  resource "wifi" do
    url "https://files.pythonhosted.org/packages/fe/a9/d026afe8a400dd40122385cd690e4fff4d574ed16f5c3a0f5e3921bfd383/wifi-0.3.8.tar.gz"
    sha256 "a9880b2e91ea8420154c6826c8112a2f541bbae5641d59c5cb031d27138d7f26"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/e2/78/f681afade2a4e7a9ade696cf3d3dcd9905e28720d74c16cafb83b5dd5c0a/zeroconf-0.147.0.tar.gz"
    sha256 "f517375de6bf2041df826130da41dc7a3e8772176d3076a5da58854c7d2e8d7a"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources

    prefix.install libexec/"share"
  end

  test do
    require "pty"
    PTY.spawn bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout" do |r, _w, pid|
      assert_match "timestamp", r.gets
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
