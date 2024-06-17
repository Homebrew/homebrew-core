class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Tool for cloud security assessments, audits, incident response, and more"
  homepage "https://prowler.com/"
  url "https://files.pythonhosted.org/packages/9a/63/0914bbc02a14bfbeda8d08c3facce48f6b4499df8011aa0e93435ea45de4/prowler-4.2.4.tar.gz"
  sha256 "611a343a4d649e395aff75f537b2aef178cd339b020bd3e3a6dce7e2fce95487"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "edafded92fbe429d78cf78cf3eb1281c14d170fcc5a157967aa42175c418f27b"
    sha256 cellar: :any,                 arm64_ventura:  "aabb9d04e71baff3bdeb5c5a4b29e44188719f4ba22c5bfa395938cbb5e4e8dc"
    sha256 cellar: :any,                 arm64_monterey: "f36a4bde57eb8921e25394527b34704b7d22be1b6c8dfda5769b11b78aa12f92"
    sha256 cellar: :any,                 sonoma:         "f40879a1a0672892319a7807da42325b3517b095758a3c8b8943c31ab71fc027"
    sha256 cellar: :any,                 ventura:        "e8a00501195441217ae344e04afe66c66f3aa08525bb1193ff622b8034487479"
    sha256 cellar: :any,                 monterey:       "589b0d3f9eacd91bf7b438c67f2d89c20fc04084d13616f9b9c1ea45f8d61f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0154a59e1db9d5be508a567c4ac92b405f6216c579aad5482b878134802f48d"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.12"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/04/a4/e3679773ea7eb5b37a2c998e25b017cc5349edf6ba2739d1f32855cfb11b/aiohttp-3.9.5.tar.gz"
    sha256 "edea7d15772ceeb29db4aff55e482d4bcfb6ae160ce144f2682de02f6d693551"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/6a/cf/de25c4f6123c3b3eb5acc87144d3e017df25b32c16806b14572a259939ac/alive-progress-3.1.5.tar.gz"
    sha256 "42e399a66c8150dc507602dff7b7953f105ef11faf97ddaa6d27b1cbf45c4c98"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/e6/e3/c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2/anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "awsipranges" do
    url "https://files.pythonhosted.org/packages/19/2e/6efa95f995369da828715f41705686cd214b9259ed758266942553d40441/awsipranges-0.3.3.tar.gz"
    sha256 "4f0b3f22a9dc1163c85b513bed812b6c92bdacd674e6a7b68252a3c25b99e2c0"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/99/d4/1f469fa246f554b86fb5cebc30eef1b2a38b7af7a2c2791bce0a4c6e4604/azure-core-1.30.2.tar.gz"
    sha256 "a14dc210efcd608821aa472d9fb8e8d035d29b68993819147bc290a8ac224472"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/cd/f1/25cba0d1f4ba1f9b9c799c4755400a3e577adcb1470cf5760fcd730b88e1/azure-identity-1.16.0.tar.gz"
    sha256 "6ff1d667cdcd81da1ceab42f80a0be63ca846629f518a922f7317a7e3c844e1b"
  end

  resource "azure-keyvault-keys" do
    url "https://files.pythonhosted.org/packages/12/ac/9a86f08659638ff2f07cb233a4f606bb765a72051a85c2622c0353eaa225/azure-keyvault-keys-4.9.0.tar.gz"
    sha256 "08632dcd6ece28657204e9a256ad64369fe2b0e385ed43349f932f007d89f774"
  end

  resource "azure-mgmt-applicationinsights" do
    url "https://files.pythonhosted.org/packages/89/37/65811225c0611bedc784f8fd954eeb5a0e4cf58dc9f46860b33444391589/azure-mgmt-applicationinsights-4.0.0.zip"
    sha256 "50c3db05573e0cc2d56314a0556fb346ef05ec489ac000f4d720d92c6b647e06"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/a5/c7/353e3a9834f9fc470c1e9876278b216289fedfb07ffb713666e5aebb7e61/azure-mgmt-compute-31.0.0.tar.gz"
    sha256 "5a5b1c4fc1a19ecb022a12ded1be8b1b155f6979d03fb9efc04642f606644bbf"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/bd/b0/eef9e425b6d43fd21875ebbd5cdee8247d134e0c0f96a1e4dc97cd4244ed/azure-mgmt-containerservice-30.0.0.tar.gz"
    sha256 "6c62e6ac590e34fedd739fe24b31b3750713a014616696ea8d44c7bcc81c06b7"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/14/95/2b2085e40f4b9de88ad256428a669583066d8ab348fc19110c7d04c3189b/azure-mgmt-core-1.4.0.zip"
    sha256 "d195208340094f98e5a6661b781cde6f6a051e79ce317caabd8ff97030a9b3ae"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/88/a3/4ff84f9fbf21f04689d351da176c72c0ad770bf4124e7d50e3fd0c877b3f/azure-mgmt-cosmosdb-9.5.0.tar.gz"
    sha256 "5d21a197de08b3638e09ad88e32da211f7bb598b7d7cfee48d61d57d69b3edd9"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/5c/e6/54879a503c28d2b1ef991f086c41c86218a82dd81a5b870c59b79a0f15ce/azure-mgmt-keyvault-10.3.0.tar.gz"
    sha256 "183b4164cf1868b8ea7efeaa98edad7d2a4e14a9bd977c2818b12b75150cd2a2"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/e4/31/ebabafe0be1a177428880a8ec0fc44d681ac9dc1ae66a70d859cb5c7fbc3/azure-mgmt-monitor-6.0.2.tar.gz"
    sha256 "5ffbf500e499ab7912b1ba6d26cef26480d9ae411532019bb78d72562196e07b"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/e3/bb/8e98bbf5f0d2c233268631c73858c066b5f883f7dda5b298d2a09c4cdc92/azure-mgmt-network-25.4.0.tar.gz"
    sha256 "a338e62d81fdbf050f802143c28cb965b07edd43800ef0504cdfa6b8854d7554"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/51/3c/c1e03a11cf3dc2567ba947cc196d695d125d0d0e86af6731a7c067c5404a/azure-mgmt-rdbms-10.1.0.zip"
    sha256 "a87d401c876c84734cdd4888af551e4a1461b4b328d9816af60cb8ac5979f035"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/89/60/19471f7f2499888da9d5abc7ff8c470a6d620fbf35657fff31df9eeb483d/azure-mgmt-resource-23.1.1.tar.gz"
    sha256 "20b6b006b544fdb19607f3f6a381105625e0bb60fbf3036f39885c4646d3343e"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/3d/90/13186657355452bdce44f27db6b194b99f78f8c185301b47624fff6d9531/azure-mgmt-security-7.0.0.tar.gz"
    sha256 "5912eed7e9d3758fdca8d26e1dc26b41943dc4703208a1184266e2c252e1ad66"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/3f/af/398c57d15064ea23475076cd087b1a143b66d33a029e6e47c4688ca32310/azure-mgmt-sql-3.0.1.zip"
    sha256 "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/49/5c/9fc3418570dcb5de5f883f909b894f9cdd77829c84afb08b7370c796334e/azure-mgmt-storage-21.1.0.tar.gz"
    sha256 "d6d3c0e917c988bc9ed0472477d3ef3f90886009eb1d97a711944f8375630162"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/d1/a9/c255592263d798843d2ccc46ee42129f5ae6b95e882dae3544938c66e449/azure-mgmt-web-7.2.0.tar.gz"
    sha256 "efcfe6f7f520ed0abcfe86517e1c8cf02a712f737a3db0db7cb46c6d647981ed"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/1b/0f/86cdaec4be486d12fd5bd2c56e835492a58d3bcd4915d24473e889b70f2c/azure-storage-blob-12.20.0.tar.gz"
    sha256 "eeb91256e41d4b5b9bad6a87fd0a8ade07dd58aa52344e2c8d2746e27a017d3b"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1e/57/a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abcc/blinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/30/3b/5b35372d4042a85547f60f7575a4548a5adc6ff20fe401ae7161c9f722e6/boto3-1.34.113.tar.gz"
    sha256 "009cd143509f2ff4c37582c3f45d50f28c95eed68e8a5c36641206bdb597a9ea"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b9/eb/4142b054eec03b2b6954a9bdae95b28a58f8dc292561fd4bcc254fcee214/botocore-1.34.118.tar.gz"
    sha256 "0a3d1ec0186f8b516deb39474de3d226d531f77f92a0f56ad79b80219db3ae9e"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/b3/4d/27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5b/cachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dash" do
    url "https://files.pythonhosted.org/packages/37/51/9728b5a7f1abfdd43909fdecac43f0ef0a591246c6c6f22f4b5eda4b74cb/dash-2.17.0.tar.gz"
    sha256 "d065cd88771e45d0485993be0d27565e08918cb7edd18e31ee1c5b41252fc2fa"
  end

  resource "dash-bootstrap-components" do
    url "https://files.pythonhosted.org/packages/a6/1e/59da44351adaaa2a747eb00993c498cadbe0f642b44ced7e7aabf368eaf6/dash_bootstrap_components-1.6.0.tar.gz"
    sha256 "960a1ec9397574792f49a8241024fa3cecde0f5930c971a3fc81f016cbeb1095"
  end

  resource "dash-core-components" do
    url "https://files.pythonhosted.org/packages/41/55/ad4a2cf9b7d4134779bd8d3a7e5b5f8cc757f421809e07c3e73bb374fdd7/dash_core_components-2.0.0.tar.gz"
    sha256 "c6733874af975e552f95a1398a16c2ee7df14ce43fa60bb3718a3c6e0b63ffee"
  end

  resource "dash-html-components" do
    url "https://files.pythonhosted.org/packages/14/c6/957d5e83b620473eb3c8557a253fb01c6a817b10ca43d3ff9d31796f32a6/dash_html_components-2.0.0.tar.gz"
    sha256 "8703a601080f02619a6390998e0b3da4a5daabe97a1fd7a9cebc09d015f26e50"
  end

  resource "dash-table" do
    url "https://files.pythonhosted.org/packages/3a/81/34983fa0c67125d7fff9d55e5d1a065127bde7ca49ca32d04dedd55f9f35/dash_table-5.0.0.tar.gz"
    sha256 "18624d693d4c8ef2ddec99a6f167593437a7ea0bf153aa20f318c170c5bc7308"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "detect-secrets" do
    url "https://files.pythonhosted.org/packages/69/67/382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7d/detect_secrets-1.5.0.tar.gz"
    sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/63/82/2914bff80ebee8c027802a664ad4b4caad502cd594e358f76aff395b5e56/email_validator-2.1.1.tar.gz"
    sha256 "200a70680ba08904be6d1eef729205cc0d687634399a5924d842533efb824b84"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/06/ae/f8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897ea/filelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/41/e1/d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829a/flask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/cf/3d/2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085/frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/31/c6/460b83c297c91c4f62d69aa9f04f3c5f8139a4f41c4b747c014939d5a802/google-api-core-2.19.0.tar.gz"
    sha256 "cf1b7c2694047886d2af1128a03ae99e391108a08804f87cfd35970e49c9cd10"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/6f/6b/4f814f372a3a3ecee569c72a639fa010ea412d4e9b4e7edd5f1dac726f85/google-api-python-client-2.131.0.tar.gz"
    sha256 "1c03e24af62238a8817ecc24e9d4c32ddd4cb1f323b08413652d9a9a592fc00d"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/be/f6/b22ef3a4b24b5b0d0fcf8426080eab66ccdfaaf73a61e37e76693c43f7f6/google-auth-2.30.0.tar.gz"
    sha256 "ab630a1320f6720909ad76a7dbdb6841cdf5c66b328d690027e4867bdfb16688"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/4f/bc/cb5c74fca58d9c37bc621642e2c2b19c004d078b472d49fb03d9fa8ffeef/googleapis-common-protos-1.63.1.tar.gz"
    sha256 "c6442f7a0a6b2a80369457d79e6672bb7dcbaab88e0848302497e3ec80780a6a"
  end

  resource "grapheme" do
    url "https://files.pythonhosted.org/packages/ce/e7/bbaab0d2a33e07c8278910c1d0d8d4f3781293dfbc70b5c38197159046bf/grapheme-0.6.0.tar.gz"
    sha256 "44c2b9f21bbe77cfb05835fec230bd435954275267fea1858013b102f8603cca"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/2a/32/fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1/h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/3e/9b/fda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954/hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/17/b0/5e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926/httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/5c/2d/3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0/httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/5a/2a/4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebb/hyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a0/fc/c4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547/importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/19/f1/1c1dc0f6b3bf9e76f7526562d29c320fa7d6a2f35b37a1392cc0acd58263/jsonschema-4.22.0.tar.gz"
    sha256 "5b22d434a45935119af990552c862e5d6d564e8f6601206b305a61fdf661a2b7"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/de/07/d01320a808abaab3426db63476adcb31f7e23fe8c08aef175d7883ea978a/kubernetes-29.0.0.tar.gz"
    sha256 "c4812e227ae74d07d53c88293e564e54b850452715a59a927e7e1bc6b9a60459"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/25/c6/688231a1c88644fc619afcbed3a7f1f2afb40b7bf751e0115f8200c1aee8/microsoft_kiota_abstractions-1.3.3.tar.gz"
    sha256 "3cc01832a2e6dc6094c4e1abf7cbef3849a87d818a3b9193ad6c83a9f88e14ff"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/5c/3a/21929600c477eb5b1deab21db52fdd06d691950b839dd3a01a3085c480ba/microsoft_kiota_authentication_azure-1.0.0.tar.gz"
    sha256 "752304f8d94b884cfec12583dd763ec0478805c7f80b29344e78c6d55a97bd01"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/0e/66/d4a53a482235be3f4d99d9ddab31546c1d8244cdbacdbf1766e31c7614c0/microsoft_kiota_http-1.3.1.tar.gz"
    sha256 "09d85310379f88af0a0967925d1fcbe82f2520a9fe6fa1fd50e79af813bc451d"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/20/72/251e030ed068a56acf13cacbd764b6e79a55dffa32baec2b686e444673d6/microsoft_kiota_serialization_form-0.1.0.tar.gz"
    sha256 "663ece0cb1a41fe9ddfc9195aa3f15f219e14d2a1ee51e98c53ad8d795b2785d"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/4d/8a/d49702369bd82995b14898ca0041869670cf3b2fcb48a15cced6c72c3da4/microsoft_kiota_serialization_json-1.2.0.tar.gz"
    sha256 "89a4ec0128958bc92287db0cf5b6616a9f66ac42f6c7bcfe8894393d2156bed9"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/28/f7/5dd2a93c4d48b3cb2f058466221b06e1465b85dea36f5cac7aace19be054/microsoft_kiota_serialization_multipart-0.1.0.tar.gz"
    sha256 "14e89e92582e6630ddbc70ac67b70bf189dacbfc41a96d3e1d10339e86c8dde5"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/a1/c9/f9c91025559d4c63237b9f232ecd106e0d8ec9a6c8953e5a7a3c4763d808/microsoft_kiota_serialization_text-1.0.0.tar.gz"
    sha256 "c3dd3f409b1c4f4963bd1e41d51b65f7e53e852130bb441d79b77dad88ee76ed"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/b3/2a/76e64e6a5f0d3d12f4b3ab2cfc8b5e4fcb6982d15213aad9c8e6b20ebeae/msal-1.28.0.tar.gz"
    sha256 "80bbabe34567cb734efd2ec1869b2d98195c927455369d8077b3c542088c5c9d"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/cb/ba/618771542cdc4bc5314c395076c397d67e2bdcd88564c6ca712a2497d1c6/msal-extensions-1.1.0.tar.gz"
    sha256 "6ab357867062db7b253d0bd2df6d411c7891a0ee7308d54d1e4317c1d1c54252"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/49/8b/431e1f1a377163118288f77ecc38a775b70224a6f8e99946c5be3521d19a/msgraph-core-1.0.0.tar.gz"
    sha256 "f26bcbbb3cd149dd7f1613159e0c2ed862888d61bfd20ef0b08b9408eb670c9d"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/78/74/a69d22f50e464bd90cbc99c42663c397ff3e9024778ef976118c0a7c9547/msgraph_sdk-1.4.0.tar.gz"
    sha256 "715907272c240e579d7669a690504488e25ae15fec904e2918c49ca328dc4a14"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/f9/79/722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836/multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/df/0d/10357006dc10fc65f7c7b46c18232e466e355f9e606ac461cfc7193b4cbe/opentelemetry_api-1.25.0.tar.gz"
    sha256 "77c4985f62f2614e42ce77ee4c9da5fa5f0bc1e1821085e9a47533a9323ae869"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/05/3c/77076b77f1d73141adc119f62370ec9456ef314ba0b4e7072e3775c36ef7/opentelemetry_sdk-1.25.0.tar.gz"
    sha256 "ce7fc319c57707ef5bf8b74fb9f8ebdb8bfafbe11898410e0d2a761d08a98ec7"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/4e/ea/a4a5277247b3d2ed2e23a58b0d509c2eafa4ebb56038ba5b23c0f9ea6242/opentelemetry_semantic_conventions-0.46b0.tar.gz"
    sha256 "fbc982ecbb6a6e90869b15c1673be90bd18c8a56ff1cffc0864e38e2edffaefa"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/88/d9/ecf715f34c73ccb1d8ceb82fc01cd1028a65a5f6dbc57bfa6ea155119058/pandas-2.2.2.tar.gz"
    sha256 "9e79019aba43cb4fda9e4d983f8e88ca0373adbb697ae9c6c43093218de28b54"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/b8/fe/27c7438c6ac8b8f8bef3c6e571855602ee784b85d072efddfff0ceb1cd77/pendulum-3.0.0.tar.gz"
    sha256 "5d034998dea404ec31fae27af6b22cff1708f830a1ed7353be4d1019bb9f584e"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/4a/42/e16addffa3eee93bde84aceee20e3eaf579d1df554633c884d50b050b466/plotly-5.22.0.tar.gz"
    sha256 "859fdadbd86b5770ae2466e542b761b247d1c6b49daed765b95bb8c7063e7469"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/35/00/0f230921ba852226275762ea3974b87eeca36e941a13cd691ed296d279e5/portalocker-2.8.2.tar.gz"
    sha256 "2b035aa7828e46c58e9b31390ee1f169b98e1066ab10b9a6a861fe7e25ee4f33"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/91/2d/8c7fa3011928b024b10b80878160bf4e374eccb822a5d090f3ebcf175f6a/proto-plus-1.23.0.tar.gz"
    sha256 "89075171ef11988b3fa157f5dbd8b9cf09d65fffee97e29ce403cd8defba19d2"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/5e/d8/65adb47d921ce828ba319d6587aa8758da022de509c3862a70177a958844/protobuf-4.25.3.tar.gz"
    sha256 "25b5d0b42fd000320bd7830b349e3b696435f3b329810427a6bcce6a5492cc5c"
  end

  resource "py-ocsf-models" do
    url "https://files.pythonhosted.org/packages/f5/09/5e0b6b8fd652350319e43d245f4f7e096518c4f2ff896a4f3c06e8edc105/py_ocsf_models-0.1.1.tar.gz"
    sha256 "b0f2d4495a2596793f75e61a1ba218edea3a2d17a2b9911d46ee0fa623cc657b"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/4a/a3/d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0d/pyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/f7/00/e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971/pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/6f/3a/1a057845b787469aa8c4ff2c126d5110d616223c82e74561b8ae56b46ec7/pydantic-1.10.15.tar.gz"
    sha256 "ca832e124eda231a60a041da4f013e3ff24949d94a01154b137fc2f2a43c3ffb"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/72/97/bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1ae/requests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/ce/70/15ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9dd/retrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/2d/aa/e7c404bdee1db7be09860dff423d022ffdce9269ec8e6532cce09ee7beea/rpds_py-0.18.1.tar.gz"
    sha256 "dc48b479d540770c811fbd1eb9ba2bb66951863e448efec2e2c102625328e92f"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/d4/01/0ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecd/schema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/c5/06/c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28/shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "slack-sdk" do
    url "https://files.pythonhosted.org/packages/cb/0f/b1176b750de28d9ee43e7fc7432f516f2013afd065e0e3bf9b475bda50b4/slack_sdk-3.27.2.tar.gz"
    sha256 "bb145bf2bd93b60a17cd55c05cb15868c9a07d845b6fb608c798b50bce21cb99"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/17/78/3f8a60037cb910e8e55b1619799c95c54a295c2db2266202fbf1f43e30f8/std_uritemplate-0.0.59.tar.gz"
    sha256 "2d91e789034810fda9d622228262e892c7bb3fb3c5caa6e317ec62e043b09cb7"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/32/6c/57df6196ce52c464cf8556e8f697fec5d3469bb8cd319c1685c0a090e0b4/tenacity-8.3.0.tar.gz"
    sha256 "953d4e6ad24357bceffbc9707bc74349aca9d245f68eb65419cf0c249a1949a2"
  end

  resource "time-machine" do
    url "https://files.pythonhosted.org/packages/dc/c1/ca7e6e7cc4689dadf599d7432dd649b195b84262000ed5d87d52aafcb7e6/time-machine-2.14.1.tar.gz"
    sha256 "57dc7efc1dde4331902d1bdefd34e8ee890a5c28533157e3b14a429c86b39533"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/db/ed/c92a5d6edaafec52f388c2d2946b4664294299cebf52bb1ef9cbc44ae739/tldextract-5.1.2.tar.gz"
    sha256 "c9e17f756f05afb5abac04fe8f766e7e70f9fe387adb1859f0f52408ee060200"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/e8/fb/4217a963512b9646274fe4ce0aebc8ebff09bbb86c458c6163846bb65d9d/typing_extensions-4.12.1.tar.gz"
    sha256 "915f5e35ff76f56588223f15fdd5938f9a1cf9195c0de25130c627e4d597f6d1"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/74/5b/e025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717/tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/02/51/2e0fc149e7a810d300422ab543f87f2bcf64d985eb6f1228c4efd6e4f8d4/werkzeug-3.0.3.tar.gz"
    sha256 "097e5bfda9f0aba8da6b8545146def481d06aa7d3266e7448e2cccf67dd8bd18"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/a6/c3/b36fa44a0610a0f65d2e65ba6a262cbe2554b819f1449731971f7c16ea3c/XlsxWriter-3.2.0.tar.gz"
    sha256 "9977d0c661a72866a61f9f7a809e25ebbb0fb7036baa3b9fe74afcfca6b3cb8c"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/e0/ad/bedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28/yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/d3/20/b48f58857d98dcb78f9e30ed2cfe533025e2e9827bbd36ea0a64cc00cbc1/zipp-3.19.2.tar.gz"
    sha256 "bf1dcf6450f873a13e952a29504887c89e6de7506209e5b1bcc3460135d4de19"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"

    # Multiple resources require `setuptools`, so it must be installed first
    skipped = %w[plotly setuptools]
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resource("setuptools")
    venv.pip_install resources.reject { |r| skipped.include? r.name }
    venv.pip_install resource("plotly"), build_isolation: false
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}/prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}/prowler aws --list-services")

    assert_match "Unable to locate credentials", shell_output("#{bin}/prowler aws --quick-inventory 2>&1", 1)
    assert_match "Prowler #{version}", shell_output("#{bin}/prowler -v")
  end
end
