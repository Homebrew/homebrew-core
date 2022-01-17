class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org/"
  url "https://files.pythonhosted.org/packages/4c/9f/6395fa31ebabdcc0363ec0f4a9553522cfdca45a7e369c0520dac8aad3ab/bzt-1.16.2.tar.gz"
  sha256 "011fca5b981830df1c1620c138e8458939527fd4035ecf9f76ae5be8a4bb29c9"
  license "Apache-2.0"
  head "https://github.com/Blazemeter/taurus.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "585200d41eb806aec9f03054542729bc79ef6a6d89ee3bebfdbfa79442699f7d"
    sha256 cellar: :any,                 arm64_big_sur:  "ad8b1e275eb1316347115f4d38dce5685a0478bfa320ab9d001d8409f609432c"
    sha256 cellar: :any,                 monterey:       "bddaf912e0e859f36d59e28dfc5a10e338f345e7ee4bff9a98a93fd8399a46c5"
    sha256 cellar: :any,                 big_sur:        "a67cf1fc3c2c2a0d712e888892ed9c98c332ecbd236331acbe910bcfa14e2b8e"
    sha256 cellar: :any,                 catalina:       "97357518845764ac60d494138448f3e061a73e90a275ea5c2d55e9804583bf8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a14814424defacd54f911cda4e8130842363f08df94668bdfe78b3a1ca5eafa"
  end

  depends_on "rust" => :build
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "aiodogstatsd" do
    url "https://files.pythonhosted.org/packages/8d/ea/d2d79661f213f09df0e9f56d25dbae41501880822e5c85a0a6d6857baa55/aiodogstatsd-0.16.0.post0.tar.gz"
    sha256 "f783c7d6d74edd160b34141ff5f069c9a935bb32636823e39e36f0d1dbe14931"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/5a/86/5f63de7a202550269a617a5d57859a2961f3396ecd1739a70b92224766bc/aiohttp-3.8.1.tar.gz"
    sha256 "fc5471e1a54de15ef71c1bc6ebe80d4dc681ea600e68bfd1cbce40427f0b7578"
  end

  resource "aiomeasures" do
    url "https://files.pythonhosted.org/packages/04/56/be4bdc775a07e79bd5fdbfe6d02aad5ae6b78a7137437deabc2c72148f06/aiomeasures-0.5.14.tar.gz"
    sha256 "37a802d3149b034647cf5917cbc83e00dde4fa1fdb922faed26721f448ee1ed5"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/27/6b/a89fbcfae70cf53f066ec22591938296889d3cc58fec1e1c393b10e8d71d/aiosignal-1.2.0.tar.gz"
    sha256 "78ed67db6c7b7ced4f98e495e572106d5c432a93e1ddd1bf475e1dc05f5b7df2"
  end

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/f3/af/4182184d3c338792894f34a62672919db7ca008c89abee9b564dd34d8029/astunparse-1.6.3.tar.gz"
    sha256 "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/68/e4/e014e7360fc6d1ccc507fe0b563b4646d00e0d4f9beec4975026dd15850b/charset-normalizer-2.0.9.tar.gz"
    sha256 "b0b883e8e874edfdece9c28f314e3dd5badf067342e42fb162203335ae61aa2c"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8e/8f/1537ebed273d43edd3bb21f1e5861549b7cfcb1d47523d7277cab988cec2/colorlog-6.6.0.tar.gz"
    sha256 "344f73204009e4c83c5b6beb00b3c45dc70fcdae3c80db919e0a4171d006fde8"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/57/b7/c4aa04a27040e6a3b09f5a652976ead00b66504c014425a7aad887aa8d7f/dill-0.3.4.zip"
    sha256 "9f9734205146b2b353ab3fec9af0070237b6ddae78452af83d2fca84d739e675"
  end

  resource "EasyProcess" do
    url "https://files.pythonhosted.org/packages/df/08/aed1831e26e275886a0ca9e5f7a50d0213c5c53c3f559dd8b85b68dbc2b3/EasyProcess-0.3.tar.gz"
    sha256 "fb948daac01f64c1e49750752711253614846c6fc7e5692a718a7408f2ffb984"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/5c/ee/7c6287928ba776567603248e160387cf4143641ecf734e393ad9b2c82475/frozenlist-1.2.0.tar.gz"
    sha256 "68201be60ac56aff972dc18085800b6ee07973c49103a8aba669dee3d71079de"
  end

  resource "fuzzyset2" do
    url "https://files.pythonhosted.org/packages/cd/57/6eba745dd426f14508d46a113deba642a4c0078f7041bfd974a16c9fbeac/fuzzyset2-0.1.1.tar.gz"
    sha256 "572c53a1f09d8d6c5b8b012b7b699327834c2d892a48e3d66ec650458a19614e"
  end

  resource "hdrpy" do
    url "https://files.pythonhosted.org/packages/47/8c/159be762f787888651f9895a60d8564d2c1df5b2581cc733823b45759cfd/hdrpy-0.3.3.tar.gz"
    sha256 "8461ed2c0d577468e5499f8b685d9bf9660b72b8640bff02c78ba1f1b9bf5185"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/84/74/4a97db45381316cd6e7d4b1eb707d7f60d38cb2985b5dfd7251a340404da/lxml-4.7.1.tar.gz"
    sha256 "a1613838aa6b89af4ba10a0f3a972836128801ed008078f8c1244e65958f1b24"
  end

  resource "molotov" do
    url "https://files.pythonhosted.org/packages/f6/c7/11ffa035894597bff22731082b27e2d9406b0a09f45fd0991f8148d6017e/molotov-2.3.tar.gz"
    sha256 "c9777d1bbbd952cdcf14e59d85d1085d0e9bfe4e12acc68008e8a97050b72edc"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/8e/7c/e12a69795b7b7d5071614af2c691c97fbf16a2a513c66ec52dd7d0a115bb/multidict-5.2.0.tar.gz"
    sha256 "0dd1c93edb444b33ba2274b66f63def8a327d607c6c790772f448a53b6ea59ce"
  end

  resource "multiprocessing_on_dill" do
    url "https://files.pythonhosted.org/packages/86/4d/4b135e2e5cd0194eb29f2ed36e9a77a07596787a9a8ac2279bd4445398f2/multiprocessing_on_dill-3.5.0a4.tar.gz"
    sha256 "d6d50c300ff4bd408bb71eb78725e60231039ee9b3d0d9bb7697b9d0e15045e7"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "python-Levenshtein" do
    url "https://files.pythonhosted.org/packages/2a/dc/97f2b63ef0fa1fd78dcb7195aca577804f6b2b51e712516cc0e902a9a201/python-Levenshtein-0.12.2.tar.gz"
    sha256 "dc2395fbd148a1ab31090dd113c366695934b9e85fe5a4b2a032745efd0346f6"
  end

  resource "PyVirtualDisplay" do
    url "https://files.pythonhosted.org/packages/2f/3d/d0edda70805ac705b09bc0183fb596f0323b0833399dae1799f7d7e251f4/PyVirtualDisplay-2.2.tar.gz"
    sha256 "3ecda6b183b03ba65dcfdf0019809722480d7b7e10eea6e3a40bf1ba3146bab7"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/f5/fc/0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3/terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz"
    sha256 "e2ef7239991699e3355d54f8e968a21bb940a1dbf34a4d226741e64462516fad"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/f6/da/46d1b3d69a9a0835dabf9d59c7eb0f1600599edd421a4c5a15ab09f527e0/yarl-1.7.2.tar.gz"
    sha256 "45399b46d60c253327a460e99856752009fcee5f5d3c80b2f7c0cae1c38d56dd"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra
    virtualenv_install_with_resources
  end

  test do
    cmd = "#{bin}/bzt -v -o execution.executor=locust -o execution.iterations=1 -o execution.scenario.requests.0=https://gettaurus.org/"
    # assert_match /INFO: Samples count: 1, .*% failures/, shell_output(cmd)
    system(cmd)
  end
end
