class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org"
  url "https://files.pythonhosted.org/packages/97/6a/a0acb0b422877d3cc2ff4bb3759752b173b59fcb6b88e4bb9f1ca8ba0a80/bzt-1.16.0.tar.gz"
  sha256 "00fac04eabc1349dd759cb9f32e8bab5f7cf2b08ce1c0d3ee25ba9adf9e66d60"
  license "Apache-2.0"
  head "https://github.com/Blazemeter/taurus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "74f43e75579eaac72b2e1edb4ed9916a4b44c382ac0ff7e39a4e9d1c84a85259"
    sha256 cellar: :any,                 big_sur:       "1e5c8fba04e0a590223e5930c1dd7d82b0c5d3886953a6b5509fe589df096d56"
    sha256 cellar: :any,                 catalina:      "ba0af87b32de700c761871864520f5051ad564b61331e6923ad0031174a874a3"
    sha256 cellar: :any,                 mojave:        "2861a7d8cea73f7e60f971ccc2fd820b8fbfe85ad56c48dba1381d36857c61e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca050c502cb7ddadec7ce2ea34bbec2970846ad0531a6387aeda64a00f8efa3"
  end

  depends_on "rust" => :build
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "aiodogstatsd" do
    url "https://files.pythonhosted.org/packages/5d/97/7c671c6f6007aab9864787c9cf2ac7f97c04b928711312d41c9748a09691/aiodogstatsd-0.15.0.tar.gz"
    sha256 "f315ef90510440c2653c7123ddeb67163425cf35ebd39690e921b812c75dfdb8"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/99/f5/90ede947a3ce2d6de1614799f5fea4e93c19b6520a59dc5d2f64123b032f/aiohttp-3.7.4.post0.tar.gz"
    sha256 "493d3299ebe5f5a7c66b9819eacdcfbbaaf1a8e84911ddffcdc48888497afecf"
  end

  resource "aiomeasures" do
    url "https://files.pythonhosted.org/packages/04/56/be4bdc775a07e79bd5fdbfe6d02aad5ae6b78a7137437deabc2c72148f06/aiomeasures-0.5.14.tar.gz"
    sha256 "37a802d3149b034647cf5917cbc83e00dde4fa1fdb922faed26721f448ee1ed5"
  end

  resource "Appium-Python-Client" do
    url "https://files.pythonhosted.org/packages/3a/52/1a055e861ebd9cb80241fc7f5690615367cea7cbbcadfba05ebc9f05cd8f/Appium-Python-Client-1.3.0.tar.gz"
    sha256 "31ed9812c1f85950378d3713aaa9a3f80d18aae045edbf4a530a7a9c98792072"
  end

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/f3/af/4182184d3c338792894f34a62672919db7ca008c89abee9b564dd34d8029/astunparse-1.6.3.tar.gz"
    sha256 "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"
    sha256 "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d6/4a/840f6cb7e922a717c765a3cdc6988aff22a6ef211d88c8d16701dfbd664f/colorlog-6.4.1.tar.gz"
    sha256 "af99440154a01f27c09256760ea3477982bf782721feaa345904e806879df4d8"
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

  resource "fuzzyset2" do
    url "https://files.pythonhosted.org/packages/cd/57/6eba745dd426f14508d46a113deba642a4c0078f7041bfd974a16c9fbeac/fuzzyset2-0.1.1.tar.gz"
    sha256 "572c53a1f09d8d6c5b8b012b7b699327834c2d892a48e3d66ec650458a19614e"
  end

  resource "hdrpy" do
    url "https://files.pythonhosted.org/packages/47/8c/159be762f787888651f9895a60d8564d2c1df5b2581cc733823b45759cfd/hdrpy-0.3.3.tar.gz"
    sha256 "8461ed2c0d577468e5499f8b685d9bf9660b72b8640bff02c78ba1f1b9bf5185"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
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
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/ed/9c/9030520bf6ff0b4c98988448a93c04fcbd5b13cd9520074d8ed53569ccfe/selenium-3.141.0.tar.gz"
    sha256 "deaf32b60ad91a4611b98d8002757f29e6f2c2d5fcaf202e1c9ad06d6772300d"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
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
    url "https://files.pythonhosted.org/packages/ed/46/e298a50dde405e1c202e316fa6a3015ff9288423661d7ea5e8f22f589071/wheel-0.36.2.tar.gz"
    sha256 "e11eefd162658ea59a60a0f6c7d493a7190ea4b9a85e335b33489d9f17e0245e"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/97/e7/af7219a0fe240e8ef6bb555341a63c43045c21ab0392b4435e754b716fa1/yarl-1.6.3.tar.gz"
    sha256 "8a9066529240171b68893d60dca86a763eae2139dd42f42106b03cf4b426bf10"
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
