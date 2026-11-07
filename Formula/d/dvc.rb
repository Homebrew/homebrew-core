class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/13/1e/957a50eab8af18a5837bf47f148b90dac36650150faca840d5c020272098/dvc-3.67.1.tar.gz"
  sha256 "0a941016a10ac8c99b5342e5a964c9bff29c191f7b3539ff3e04910d828f82ab"
  license "Apache-2.0"
  revision 20

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2f4686934f33e2950f6610579dd8a4af39fc94f7709d61199507011251ba0651"
    sha256 cellar: :any, arm64_tahoe:       "753db0728b4f3b626f5b2a0f8561d678e4353c3819ad578ac920e0df92ac50d8"
    sha256 cellar: :any, arm64_sequoia:     "bf30afca4cdc09ceb910060af7c09b254301e247634ea4fca9ebd78b102a4094"
    sha256 cellar: :any, arm64_linux:       "8f52824f181d50dee2f878584bd2e9ffddd09a77ea73537c28bd032b49a9c974"
    sha256 cellar: :any, x86_64_linux:      "aa8f9d076c33941518718baf9ca31b9818213aed602574f52d9444e568614661"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "cmake" => :build # for pyarrow
  depends_on "ninja" => :build # for pyarrow
  depends_on "openjdk" => :build # for hydra-core
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "apache-arrow"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pydantic" => :no_linkage
  depends_on "pygit2" => :no_linkage
  depends_on "python@3.15"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages package_name:     "dvc[all]",
                exclude_packages: %w[certifi cryptography numpy pydantic pygit2],
                extra_packages:   "boto3" # https://github.com/treeverse/dvc/issues/10966

  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/f4/29/9937905acfaf3e4826d7782f8efab845bb11eaa2e24749a16eeab32e7fa0/adlfs-2026.8.0.tar.gz"
    sha256 "b78a01bd892c2a99f461b2b2ef4592c2eb45934e728f318472291ccaa6378e06"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/16/40/659f2ac3915d329e3e8e5bf674d35ce1774f3117c6f60339d5e05e505c36/aiobotocore-3.10.0.tar.gz"
    sha256 "35480ef11c51e23087273b85d97f80da2f356a46ce5f3fb88e24483cd343ffdb"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/6c/4c/bdccd81e9ee225b69c60e7766c9a5b05364f118f4d383713b89a682d772d/aiohttp-3.14.5.tar.gz"
    sha256 "5558a7f5a05af9ecf744af91e5baefc436f93c9333e656c27ec253f9a6bbe178"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/9d/61/ebda4d8e3d8cfa1fd3db0fb428db2dd7461d5742cea35178277ad180b033/aiohttp_retry-2.9.1.tar.gz"
    sha256 "8eb75e904ed4ee5c2ec242fefe85bf04240f685391c4879d8f541d6028ff01f1"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/fd/3c/53c4a17a05fb9ea2313ee1777ff53f5e001aefd5cc85aa2f4c2d982e1e38/aioitertools-0.13.0.tar.gz"
    sha256 "620bd241acc0bbb9ec819f1ab215866871b4bbd1f73836a55f799200ee86950c"
  end

  resource "aiooss2" do
    url "https://files.pythonhosted.org/packages/74/c5/d704b3943f1cb5cbd8f0bffe597411312b15309917e891712d5bf62fb638/aiooss2-0.2.11.tar.gz"
    sha256 "6409e0f7ab66bed364a1c9639b657437175534de160f330d0103a445a2e89a59"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "aliyun-python-sdk-core" do
    url "https://files.pythonhosted.org/packages/ea/38/eb3be49159d6442e68189f21a2205a199b51ca46cf42a3f874e695ff0ba9/aliyun_python_sdk_core-2.16.1-py3-none-any.whl"
    sha256 "0f25a6e8ec1ea29c76610278cff81cbff85149a6e692bf2398a6f9b77e5e7424"
  end

  resource "aliyun-python-sdk-kms" do
    url "https://files.pythonhosted.org/packages/a8/2c/9877d0e6b18ecf246df671ac65a5d1d9fecbf85bdcb5d43efbde0d4662eb/aliyun-python-sdk-kms-2.16.5.tar.gz"
    sha256 "f328a8a19d83ecbb965ffce0ec1e9930755216d104638cd95ecd362753b813b3"
  end

  resource "amqp" do
    url "https://files.pythonhosted.org/packages/4b/46/64c69cdd9705a5b312920cf76c3cb7c2c4718ffeafbfbcf87a842890765e/amqp-5.4.2.tar.gz"
    sha256 "9362660c4a31150cf18e78cae2ce8aa1e929fc6c6739e69f6dd5dbea9c3edc82"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/0f/c5/41a0d5477865c48cee65050586092dc3ba3fc1c52e29b47fba08d3a44581/asyncssh-2.24.1.tar.gz"
    sha256 "efcd36e9b35f79873535b06444a7c9b0a3c61d97081b208c7fdd3fd8a40f1eca"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/08/3f/23b2643edfae61210baee60eec95873a4ad4fc6a7c096a725f240a0bf4db/atpublic-9.0.0.tar.gz"
    sha256 "61ea62d8445d2aaa83b6dffaa3d90f99fcec10e16683ee9b13792cdcdafa0966"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/cf/33/0b881d0093d64c965bb20fcf71b806c7097881b544a2a55d519cdcf3bab9/azure_identity-1.27.0.tar.gz"
    sha256 "6a4c50e25e8e9a47b324a95ad024897e56cb3c6241e0094e93b126a2bf71edc5"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/6f/18/eb2ade6eede419d33493016ec3243ca9860f67d0bc71aa0461cda2cad0c4/azure_storage_blob-12.31.1.tar.gz"
    sha256 "0d6e5b860a1357efc602db04cfa7c9950ac86126edcf7db89320cde281555fe5"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "billiard" do
    url "https://files.pythonhosted.org/packages/96/ba/4ee8c6d14b3e9b5ce89b5b070f1352e6cadefde3f6bc36afcfee5e7158a2/billiard-4.3.2.tar.gz"
    sha256 "9eb83c99b1cf7acb1fed86c1dfd477157000a1a2c0108005c1e5837b55d2acba"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/94/a7/61f0295f79dfdcebb5aa01f86c614fac7e1294faabbd66259d3609c50539/boto3-1.43.117.tar.gz"
    sha256 "f3d314908d866b577ee6b74ed432c21e565c4c4dbd640ef3fd5e0da30fa13a98"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6e/a0/d0a5c44ad6a01f195681ddcb4ce203f06c712811daf1d15f8f8785e8a9f8/botocore-1.43.117.tar.gz"
    sha256 "71993702832cc37c2495048b9945f2929d306fccb3fb767e9964e437e637fa6c"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/ef/f7/166bfd22cbd0dd4f77715ddd207881c1332cd1f304d79b1a123aff7cdf10/celery-5.7.0.tar.gz"
    sha256 "6a5dfcf6662287204f009a02002b9e66c83d4105e47ebabdc7079108772fc6f0"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/30/ce/217289b77c590ea1e7c24242d9ddd6e249e52c795ff10fac2c50062c48cb/click_didyoumean-0.3.1.tar.gz"
    sha256 "4f82fdff0dbe64ef8ab2279bd6aa3f6a99c3b28c05aa09cbfc07c9d7fbb5a463"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/c3/a4/34847b59150da33690a36da3681d6bbc2ec14ee9a846bc30a6746e5984e4/click_plugins-1.1.1.2.tar.gz"
    sha256 "d7af3984a99d243c131aa1a828331e7630f4a88a9741fd05c927b204bcf92261"
  end

  resource "click-repl" do
    url "https://files.pythonhosted.org/packages/28/50/bea78619ff1fc0fbd61882f64a1302a8abb2ea0b3db92907042d0e362df2/click_repl-0.4.1.tar.gz"
    sha256 "c32a1cf6f95e5bd6e92076f81ce24eafd33f2f0ffb0135887e335b8e446d1c0b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/0c/31/84b2b2113c2c972431582bffd74f0d04b5efd9126538127b766275580950/dictdiffer-0.10.0.tar.gz"
    sha256 "0b912acf663949d73b820d3ed59362140a188ab742c94efe13c762dbd24cbbd3"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/b5/ce/e1fd64d36e4a5717bd5e6b2ad188f5eaa2e902fde871ea73a79875793fc9/dpath-2.2.0.tar.gz"
    sha256 "34f7e630dc55ea3f219e555726f5da4b4b25f2200319c8e6902c394258dd6a3e"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/01/d1/01adf1db003374db4c2a70f7bae757ddfc39a33d9fb5ab765522b4d339e6/dulwich-1.2.21.tar.gz"
    sha256 "5d3939f64883e6799614cab708ef4ee9ef415dd6dcad47527cdbb0eea43bf3a2"
  end

  resource "dvc-azure" do
    url "https://files.pythonhosted.org/packages/d0/12/c22ff8bbae5939bb31d773b6dba1d4dc93292a2d65e40e18b35927e0539f/dvc_azure-3.1.1.tar.gz"
    sha256 "db2f9b069e68d1bbae67f953a373ebde42d404d6c7e894d95d597c8ad753a660"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/c3/2f/e00e933d10512ca7ec4f3f2f450d915e6bed4c01cf666d50a1a8f9b033ff/dvc_data-3.18.3.tar.gz"
    sha256 "61c8085a7c5b5e3ecaa86d63c3f22dc7c951a5dc55bd0a1bb5afa15377a25b1a"
  end

  resource "dvc-gdrive" do
    url "https://files.pythonhosted.org/packages/b5/ab/278694dd93e8657d590408e37e440ead5ca809af6c265ca248df10942270/dvc-gdrive-3.0.1.tar.gz"
    sha256 "ad7c9cd044083745150a57649eb4ef9240348f054bed5a8f8aa5f1820c6384ec"
  end

  resource "dvc-gs" do
    url "https://files.pythonhosted.org/packages/00/b6/69fb69f52333854460779eda1d2a3516176c4c5335f713555aa4080e6eda/dvc_gs-3.1.0.tar.gz"
    sha256 "4218560ff1d5196fd0c79162655cd79c5134fa61ebe34a3a507faf0749226eee"
  end

  resource "dvc-hdfs" do
    url "https://files.pythonhosted.org/packages/ea/b5/42a2a3b3897f6e7c0b77c1408ed27e472ffdf61c5a1fec91d396177da275/dvc-hdfs-3.0.0.tar.gz"
    sha256 "286443cb2c107ad53e73d8d6c4af8524b6e3b6b88b1543c8bc0544738aeb9fee"
  end

  resource "dvc-http" do
    url "https://files.pythonhosted.org/packages/33/e6/4fb38ab911a9d90fbe2c7759c430814fe2253760304a9de0d3ebd6e27c20/dvc-http-2.32.0.tar.gz"
    sha256 "f714f8435634aab943c625f659ddac1188c6ddaf3ff161b39715b83ff39637fc"
  end

  resource "dvc-objects" do
    url "https://files.pythonhosted.org/packages/f5/3a/90c765395fe282132aac3fb4fb8ba2839437c459125a38af0c4865b7b963/dvc_objects-5.2.0.tar.gz"
    sha256 "969bc19847b76604327631ce0ad0f287efa549d87bac028b5c2eb17a0d610984"
  end

  resource "dvc-oss" do
    url "https://files.pythonhosted.org/packages/c2/32/08789c1aa80da525fd7bd0fbef4c11431aabf32cc9446e28a589daf9fa2e/dvc-oss-3.0.0.tar.gz"
    sha256 "1047f734022fcd2b96d32b06bf6e0921cd0a65810f7fc1e9b0fac29a147b6a9a"
  end

  resource "dvc-render" do
    url "https://files.pythonhosted.org/packages/be/15/605312dbdc0931547987ee25a9a3f6fcabf48ca1436039abcd524156b8e2/dvc-render-1.0.2.tar.gz"
    sha256 "40d1cd81760daf34b48fa8362b5002fcbe415e3cdbcf42369b6347d01497ffc0"
  end

  resource "dvc-s3" do
    url "https://files.pythonhosted.org/packages/9b/79/204d9b9f811d67f972339e4f0cf7cfa1f76928b998c662e0d07fc16064be/dvc_s3-3.3.0.tar.gz"
    sha256 "f1d718a44dcee5191beb46e44adf4bb22882cb8e9ccdd8f2640078abc56457d4"
  end

  resource "dvc-ssh" do
    url "https://files.pythonhosted.org/packages/cc/31/d8c8340ab605cb0d5427be7911da0baa6d1471a43611f54100aa456ce2c8/dvc_ssh-4.3.0.tar.gz"
    sha256 "3607f31195b95a60da3fce5aa5138cbc84f2e78e421ec7bdcfde310bf270f4e0"
  end

  resource "dvc-studio-client" do
    url "https://files.pythonhosted.org/packages/cd/ee/c3c2901383633a2bd622a931948649a001a9836c803bb63580adeaa28299/dvc_studio_client-0.23.0.tar.gz"
    sha256 "cd5582fcf9dc281a00cceb56b6dd6d7503052b0661285dac3315bbb5d3add240"
  end

  resource "dvc-task" do
    url "https://files.pythonhosted.org/packages/19/ef/da712c4d9c7d6cacac27d7b2779e6a97c3381ef2c963c33719d39113b6a3/dvc_task-0.40.2.tar.gz"
    sha256 "909af541bf5fde83439da56c4c0ebac592af178a59b702708fadaacfd6e7b704"
  end

  resource "dvc-webdav" do
    url "https://files.pythonhosted.org/packages/a0/12/71c963fa0f1c1200983c40ab54978ba36e2a459a646c7266248c8594dd37/dvc_webdav-3.0.1.tar.gz"
    sha256 "3c0d04afb0985a2c156f0b719f4b9437ce4acd346647d8f6fee043b5e917c76e"
  end

  resource "dvc-webhdfs" do
    url "https://files.pythonhosted.org/packages/36/f5/249f881b2e035d6c7362733986b5545fa8c88fed451972be5d0fedae5fab/dvc-webhdfs-3.1.0.tar.gz"
    sha256 "6e894843d15ce766a05c616deda9d9bc361248e93bf9ea338b996e6e51ea0fea"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/9a/6d/8f96c1eb3aa1b448a718866e88e0201145a35e80ffcee3b1b88543d3e740/entrypoints-0.4.2.tar.gz"
    sha256 "3bebd9a2cd05e08b123be74c277b36de4a38e899dba6a84ac9962ebe0c22ece6"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a3/1d/d730c664fcb4f1d264a722722a3134cf0881854f73c1fd58abf87572f232/filelock-4.2.9.tar.gz"
    sha256 "96530b7c538d4ea08493ab067247aab7948c54d8cd622cce711c97cccc5d9896"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/0b/d0/34bf1bafa4d54e4ec20ca40856e991ffe7fdfd53831a2a36a7eb356508c8/flatten_dict-0.5.0.tar.gz"
    sha256 "ca89664d0bc9552d525ee756726b5a755c17f65b5bf23d0a1f07841f181428b7"
  end

  resource "flufl-lock" do
    url "https://files.pythonhosted.org/packages/c8/82/a41c7a3b2493f1bdf2ee4adc6c8e164bb8ca7bc8bf4f7e1400f6c0b232d6/flufl_lock-9.2.0.tar.gz"
    sha256 "333ffe41bda10bd11e21817e7bb699d5f87dfc56bf036e573f0a7208050c23ae"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/77/cd/9be253869fc42e764de7f3dedd6969af7d44ff9c3375214a3442a6f3fc08/fsspec-2026.9.0.tar.gz"
    sha256 "0f08147951c8cb31d844c3547d631053b127863b60be04cf06e121333ee0e2fe"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/03/2c/c704bc76973088cb17b663a467aab7e2d46a999d647116db145daa2121ed/funcy-2.1.tar.gz"
    sha256 "8979feb3de7120afd1d00e5a8eae810c1942e4bfbc91697151e9ee1e49f79284"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/ed/78/e3eeed58d314b3906c36896999b5f15bd1e0669fba7a8d6733aee046234c/gcsfs-2026.10.1.tar.gz"
    sha256 "ebdd435946894c47b17a2e4ac2d5f2832e8cde520e227db65d9b901c01fd7d28"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/ff/fee293f1ec3e1b64db6eb270e00964f29c086d769201474cedb8d1608930/gitpython-3.2.1.tar.gz"
    sha256 "0f1229ec5c057bdabdeeda8bda4f17bda679ab33dbccc00f24e6a480553c8613"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/72/ef/63d89cb580f3a42c51db53b3d151352aa61b9c87ea8cfdd8d24ee6caa09d/google_api_core-2.44.0.tar.gz"
    sha256 "5ab9a396965c1227d7dea4581e562b7018aa2bca96d2de0be5eb70dc9c8ab3a1"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/b6/47/077e889d3c618d971d3bce4ab198c645a607276b8d4bb151cfe78d2c92bb/google_api_python_client-2.201.0.tar.gz"
    sha256 "d5691982abd7287f53cb0b0e0c6a9984d4103cf864ea0a88cb6e4347bbaf70de"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/c4/38/d79ab09dcfc1e1638d887c8f65657619d3ebc454165c558ef79355971ce3/google_auth-2.62.1.tar.gz"
    sha256 "3c8e1ce2553784ae17fd220e6f88df3281d86ab98019278f436d06dffab17a9e"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/bb/6d/a511ca64d5412850e351bdec6bb224e5090749bd85c186135e8fdb4fd85a/google_auth_httplib2-0.4.4.tar.gz"
    sha256 "b931de392c20cfaa351cd789274922bd8cdc001e0e9e96de31b39d71347f8e16"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/c4/40/1d7901e454831247e377ef3f642cb857cc0e82ec4d2380b7a148a48f20d1/google_auth_oauthlib-1.5.0.tar.gz"
    sha256 "b351107c7dd9017f426cbb0272ea1bc04f469020fd18f4443c7d40362e0b1510"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/55/71/d6081acadf55d4233271c39860f0d140ef61fbdb4bceb2075e9c2905d947/google_cloud_core-2.8.0.tar.gz"
    sha256 "365f8e4518ae81c8101b8dea5fc1c32a960badedb8b511f19db2843cbbd285d2"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/1d/d8/9d6444c1bc301bd4bad36cc91306524e8aba670cbefcc0d2fc184c88fbea/google_cloud_storage-3.17.1.tar.gz"
    sha256 "b24df37900f5e0a93518bd7d3a2a7b7b48d8a1e72add8eb57d53a38b8b2b0640"
  end

  resource "google-cloud-storage-control" do
    url "https://files.pythonhosted.org/packages/7e/92/3f294c663d28081f48e5abcde340e300556e679d6edb4f10392b277d9c7a/google_cloud_storage_control-1.17.0.tar.gz"
    sha256 "b49f4d9e2d43e18cc6760e37a99ff5d9f674f4532e43e6d84fa69ec194c82bbb"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/fa/25/9cb0c1c31c45b893eb8f11ae70b3f4309432d59b5acaebca5dbe791729a4/google_crc32c-1.9.0.tar.gz"
    sha256 "7b8c84c3d159ab6817fe3f74e6e6cef099c3f95dcec3abc0d8afb1404642efbe"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/cf/64/df6a482d5aa39d7f7be186d892377d605cae6c88525fd851d456e8bbe9c9/google_resumable_media-2.11.0.tar.gz"
    sha256 "febd83686752799661b4de575f0b993c5c25c349a5362556fc4d7be164056a37"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/62/b6/bc095b23a3e0d978e75c8c18cabe4c11f791837410670e4486f0d539bfba/googleapis_common_protos-1.76.0.tar.gz"
    sha256 "71db0e44a1d4c2dd024ebad44ca67129cc1e2892e4861df466764749d5ef8642"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/95/0e/4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659/grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/97/24/0ef24ccdd91ce07be7d6466d39becdd4fbb33e52426ba2391fe334d24bca/grpc_google_iam_v1-0.14.6.tar.gz"
    sha256 "fc0a683ace0a149184fcd08d667dd64d51ae65e5698e86f7136aa6002a8b5373"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/f0/03/f9e805772d4d01da2a1754a5f63c58601eacaf8f1e878729217188de7d16/grpcio-1.85.1.tar.gz"
    sha256 "5f530287d5de5f7f66089ead81de44f6787162944dab3922efa65dfdff108a1d"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/fe/16/0a161d0016f6e318ebf217780a91e007a67d9d244a06f79caeef689f5f02/grpcio_status-1.85.1.tar.gz"
    sha256 "3f6ba6090d794b7148b23f03355addd56bee2b78174a12784c4d9b4e28c8928e"
  end

  resource "gto" do
    url "https://files.pythonhosted.org/packages/66/9c/cf74e391f76ff2afd7aee9bdd0f1b191c0522ba8190439bfa3b2672f222a/gto-1.10.1.tar.gz"
    sha256 "e2a008650e7be42b7e3dd65e2eef360d466553e3b41d8f37dae38328d84fd224"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/93/da/affa4b2adc11468c7d88d9b4258cac432479046edcf212284b55d4528593/httplib2-0.32.1.tar.gz"
    sha256 "37900eb8a74576bd99fc39ae1dc8409f95f965d45b56cbcb2194bb55f58a90e1"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hydra-core" do
    url "https://files.pythonhosted.org/packages/7c/1d/e1ad315ca93f1b090b0782942535fea8344e8b2d749c92117b2bf45f4407/hydra_core-1.3.8.tar.gz"
    sha256 "18d5dfb841734a936507e75e7b8390b406ed22494f7fb8b4b7b7c122102de3d5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "iterative-telemetry" do
    url "https://files.pythonhosted.org/packages/d2/b6/f17d6e80252b7be6ca4d9463db226ce7863d26287f16f1347e981cd2f3d8/iterative_telemetry-0.0.10.tar.gz"
    sha256 "7fde6111de6fa4acf5a95a6190cc9cc5d17d835a815f0a18ece201f6031f4ed6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/58/ce/0e9597a4b2348dade473d3e177ce32ca570f67b479ab9a292a90cb88f892/knack-0.14.0.tar.gz"
    sha256 "2ddd32fd6343ec9b6ed0da729b212362d0e6b1208c0162633c90cb6f94a05877"
  end

  resource "kombu" do
    url "https://files.pythonhosted.org/packages/57/31/3e632ebce43c684dcc6eead4660b33307e6153be87e33c14e1ed9875deff/kombu-5.7.0.tar.gz"
    sha256 "31e62fdfd2381caa3422f8e02b84a491d9a2180ddda74507b57f4cb1e1c2c2c9"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/bb/85/747d28986a44b715cc51cf57aa021c8fd94e9614064261ceec77320e8b0b/msal-1.39.0.tar.gz"
    sha256 "6ab7de335e6d7f5717e2c7e1dbf86e4dda2f6acf3c56773b78dc53ebc6395b5f"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/7b/6b/29ef8e752f5854dcc267ded0652c475bec99b86f255957a0d4fcad657b18/multidict-7.2.1.tar.gz"
    sha256 "e8af3e6f1bdbc31fd762b094133b478b89988eaebc63cbe82b1d9e3bbd15cede"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/dc/76/3af777226b63a5e64a6b36b1ec5855c14e2b94a37096d4760e595fc43511/networkx-3.7.tar.gz"
    sha256 "fd77a511bd90f39f3d016351345b52cf5319b813bdca01de3f755d3cca62e96a"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/33/17/2bb072de0b990303c985f26869fd47bb179024a051f47e7f9d208eb92f8e/oauthlib-4.0.1.tar.gz"
    sha256 "3d73febdb6faa00f277c81fb04be7b7586fb96fc3b7f0b9c772dada69a25ede7"
  end

  resource "omegaconf" do
    url "https://files.pythonhosted.org/packages/ce/3d/e4b57b8d9008c6ebe0d5eff901f91d5700cf7bdb8c8863df817463a7fd5e/omegaconf-2.3.1.tar.gz"
    sha256 "e5e7de64aeebeddaf8e6d3f7a783b32ac2a01c0fbd9c878012caecb891a1f42a"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/d5/63/b6c355af7f04a8a1d5759fa6fc47539e25ef8e6f2745372a242fdadcac65/oss2-2.18.4.tar.gz"
    sha256 "be1e7a871a8cc267726367333017d78333ee8fae88c727ad61396f59c1c0e4d0"
  end

  resource "ossfs" do
    url "https://files.pythonhosted.org/packages/b1/8a/d0ca844e613d0b8d4b80f8098528a599f2fbf05c3853a75d27d3e645928e/ossfs-2025.5.0.tar.gz"
    sha256 "722e7044fbcd84cc992e5cd6821d5f19bed334216c140d6e46ffb21979d49ce0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/46/70/783e33ffbb4466cc154a94f79b869b92a451e2bd45605054e68ff68b7af6/proto_plus-1.29.0.tar.gz"
    sha256 "cfb4e62ad7e13dd18f346cabbda00cab39930d36a05791fd81ddb074d6ee884f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/bc/5e/9cb2a56d5e293aab4e2fbecc5b0620d93227d66b8d5a63c554c31e1f80fe/pyarrow-26.0.1.tar.gz"
    sha256 "93affcbd8a343e98dc19e9ec8fe17271ebf8fe98102d8b7454175074409f8b72"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/88/7e/3c0da41061a2021cac7cd524fd57092adbe5b515e8bf9005702e366802e2/pyasn1-0.6.5.tar.gz"
    sha256 "6b11616a6bcf3a40e635f082bb232fa57b5e0dd7f517bd7ddd69ec3794508a47"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/61/52/6bf92ead9cfcfc788d9f07f2f8dad4592b190d36ed3d26a5985bbf95ff5d/pycryptodome-4.3.0.tar.gz"
    sha256 "663fc5e1c4a3562d00c3a9b265fb94ef5f68c6085d982638b83e713af5487c06"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/d0/31/21d21e0e38a8f5f7a7f0cde22820117b6d17d6bc36f348129527f915d7f4/pydantic_settings-2.16.2.tar.gz"
    sha256 "3dc08ffabed2bbd5dc2dd55ead7b78b4e4c5cd776aecd04310db5f1224caaf46"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/50/35/b17cb89ff865484c6a20ef46bf9d95a5f07328292578de0b295f4a6beec2/pydot-4.0.1.tar.gz"
    sha256 "c2148f681c4a33e08bf0e26a9e5f8e4099a82e0e2a068098f32ce86577364ad5"
  end

  resource "pydrive2" do
    url "https://files.pythonhosted.org/packages/fa/e2/67534dd1e644f170c750546b899963f5fb5f40d9719273eb1ec42a29d44d/pydrive2-1.21.2.tar.gz"
    sha256 "2a21c8319a225943c70e7566eb13a1524d1d7193621de1eb8e5f95e037641508"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/ff/06/31cf0821ada10cb65be108388ddf08d6c6990af90369db26b86776c3e86c/pygtrie-2.6.2.tar.gz"
    sha256 "879264597743ef52bf80f2dff085364088c0848ae22544db95dad2bf52e06471"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/35/d3/d6a9610f19d943e198df502ae660c6b5acf84cc3bc421a2aa3c0fb6b21d1/pyOpenSSL-22.0.0.tar.gz"
    sha256 "660b1b1425aac4a1bea1d94168a85d99f0b3144c869dd4390d27629d0087f1bf"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/f7/fe/ab89ab94cc1293849bc1a60876b589007bdd43f59a06ca309e717bd45dc7/s3fs-2026.9.0.tar.gz"
    sha256 "ec078ff0122d28fd21d36ea4987794e4f42ecd6e8785eeaa083208771c1464e5"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/90/d5/62ab01546616c42d05e11fe133ce80e1d5c5c601bfc391de41f52e32ce66/scmrepo-3.6.2.tar.gz"
    sha256 "750741af151e4c602dbf1456b49c7a1d27844527ba94db1e0c580b167cbd9316"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/92/f5/e1dfe8e1d91c54ce212fd93916eb01fd1c590f413be0a0978c39a97aa1bb/semver-3.1.0.tar.gz"
    sha256 "14bc073439513d7773662a338f4db9829cf16c12b74b9568e2d2689975fbd7fc"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/8c/e2/bcf761f3bff95856203f9559baf3741c416071dd200c0fc19fad7f078f86/shortuuid-1.0.13.tar.gz"
    sha256 "3bb9cf07f606260584b1df46399c0b87dd84773e7b25912b7e391e30797c5e72"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/ff/dd/e58588cf2d02266d504f4399979740b8b2b61fbd7719a89578afaa6558a3/shtab-1.13.0.tar.gz"
    sha256 "0a5be9d7ab2b4549e9a38252abcd5ecf5ec6813ecd80c6b06fa851bff55a5085"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "sqltrie" do
    url "https://files.pythonhosted.org/packages/60/63/ff6509fa8f06bbaa8cffdba4dd9c01bfd9c6af3dc40c95d7669a09d2f659/sqltrie-0.11.3.tar.gz"
    sha256 "358fb71b236311c74598616e071b43b38fc74921e5724c4659e47998e8b27e95"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/b2/70/0f5b8a8b2ba771102fe24f01436626f77d906f3c8338e40e02466a5bee08/sshfs-2026.8.0.tar.gz"
    sha256 "1a52db45dce437c62d4a47cb8b4f72bc230300acda536a6d3bac984795262917"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/d8/89/2bd035df331499589fc92e59375c17c6cea6a500453b2c5f6a6ec9572825/tzlocal-5.4.5.tar.gz"
    sha256 "ba976898bad27945178c9ca25c222c19e322b30c10342b9f40b46714f70d2d5f"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "vine" do
    url "https://files.pythonhosted.org/packages/bd/e4/d07b5f29d283596b9727dd5275ccbceb63c44a1a82aa9e4bfd20426762ac/vine-5.1.0.tar.gz"
    sha256 "8b62e981d35c41049211cf62a0a1242d8c1ee9bd15bb196ce38aefd6799e61e0"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/92/f4/0738e6849858deae22218be3bbb8207ba83a96e9d0ec7e8e8cd67b30e5ca/voluptuous-0.16.0.tar.gz"
    sha256 "006535e22fed944aec17bef6e8725472476194743c87bd233e912eb463f8ff05"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  resource "webdav4" do
    url "https://files.pythonhosted.org/packages/bb/2d/3d20527d81b25ef039ac92c15f4b9c8760b099e4e0fbf2b1d5d24ef78c3f/webdav4-0.11.0.tar.gz"
    sha256 "7062c6640e0520bfbd49862bdd335db839e519bf2ca02cd4f89957069ed600ea"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/9c/b0/f752d19e1e83ab8bd64aeccfde32ff086aee3ef08520f7340b69a8d0a4d2/wrapt-2.5.2.tar.gz"
    sha256 "551cb49e88b3722faad780303833bc4fa70685fb1773270fb98b40d39d9fddbf"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  resource "zc-lockfile" do
    url "https://files.pythonhosted.org/packages/f8/3f/9def84ea337e9ad911ac7b16c069d755f6b02961a297068c08f05f3c6700/zc_lockfile-4.1.tar.gz"
    sha256 "498f37d33a36d1b1534ea31a0fbe3b5d371c862baeb8805f467a6d39948011ef"
  end

  def install
    # dvc-hdfs uses fsspec.implementations.arrow.HadoopFileSystem which is
    # a wrapper on top of pyarrow.fs.HadoopFileSystem.
    ENV["PYARROW_WITH_HDFS"] = "1"

    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/3.0.0/scripts/build.py#L23
    File.write("dvc/_build.py", "PKG = \"brew\"")

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"dvc", "completion", "-s", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/dvc doctor 2>&1")
    assert_match "gdrive", output
    assert_match "gs", output
    assert_match "http", output
    assert_match "https", output
    assert_match "oss", output
    assert_match "s3", output
    assert_match "ssh", output
    assert_match "webdav", output
    assert_match "webdavs", output
    assert_match "webhdfs", output
  end
end
