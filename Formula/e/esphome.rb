class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32/ESP8266 super easy"
  homepage "https://github.com/esphome/esphome"
  url "https://files.pythonhosted.org/packages/ea/2b/131578f2dcb9d9e1199b204fd235fecb32325aadded9fe7d1af80f7310ac/esphome-2024.9.2.tar.gz"
  sha256 "caa9569b11706d3ac593372ffec80521af032b30348ae7e2f2b78fe6fe9a401a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2060e59b1f42728e4b0f4ae6cf1f39203920326d7a2713d391242aaa39fc028d"
    sha256 cellar: :any,                 arm64_sonoma:  "48eb42c225da0611d071fff1f7a866a92f7283fd94ffac03eeee2ed4dbcb82a2"
    sha256 cellar: :any,                 arm64_ventura: "23d30f820b22066c7052c37225d6a6a1cca8dd7ab96285b022b2a761a8d77d39"
    sha256 cellar: :any,                 sonoma:        "393afc07be16d85aba4ec42a1d6c4842c38ba72ed92c3fd4d20c8a9c4f95f36c"
    sha256 cellar: :any,                 ventura:       "b74e2688b814563bdaa0b225ae934107ce8eb58371a6d3d0f426dcbc0460b885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7ee7ea3347e83ed36120827b169f7e3afaf6338690445dcdf42726cdcff17b5"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libmagic"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python-setuptools"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "aioesphomeapi" do
    url "https://files.pythonhosted.org/packages/89/4d/e5b6826e7256abc0783876a382797fd26b632b860eecc61698abb46a52ca/aioesphomeapi-24.6.2.tar.gz"
    sha256 "dfde91df6b115cddac95d82ca968847a7f726b2a0d0ecef6cee8c065bdbb701c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/bc/69/2f6d5a019bd02e920a3417689a89887b39ad1e350b562f9955693d900c40/aiohappyeyeballs-2.4.3.tar.gz"
    sha256 "75cf88a15106a5002a8eb1dab212525c00d1f4c0fa96e551c9fbe6f09a621586"
  end

  resource "ajsonrpc" do
    url "https://files.pythonhosted.org/packages/da/5c/95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1/ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/78/49/f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8/anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/5f/39/27605e133e7f4bb0c8e48c9a6b87101515e3446003e0442761f6a02ac35e/argcomplete-3.5.1.tar.gz"
    sha256 "eb1ee355aa2557bd3d0145de7b06b2a45b0ce461e1e7813f5d066039ab4177b4"
  end

  resource "async-interrupt" do
    url "https://files.pythonhosted.org/packages/ef/7c/5a2d74465037b33ccdaf830e3d9ac008bccdbe4b0657983b90dc89191626/async_interrupt-1.2.0.tar.gz"
    sha256 "d147559e2478501ad45ea43f52df23b246456715a7cb96e1aebdb4b71aed43d5"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/0d/c7/a85f206e6b2fddb93964efe53685ad8da7d856e6975b005ed6a88f25b010/bitarray-2.9.3.tar.gz"
    sha256 "9eff55cf189b0c37ba97156a00d640eb7392db58a8049be6f26ff2712b93fa89"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/d8/d0/d6f57409bb50f54fe2894ec5a50b5c04cb41aa814c3bdb8a7eeb4a0f7697/bitstring-4.2.3.tar.gz"
    sha256 "e0c447af3fda0d114f77b88c2d199f02f97ee7e957e6d719f40f41cf15fbb897"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/87/7e/eae463f832f64b3a1cb640384d155079e7dd2905116ab925e9bb04f66e75/bottle-0.13.1.tar.gz"
    sha256 "a48852dc7a051353d3e4de3dd5590cd25de370bcfd94a72237561e314ceb0c88"
  end

  resource "chacha20poly1305-reuseable" do
    url "https://files.pythonhosted.org/packages/c1/ff/6ca12ab8f4d804cfe423e67d7e5de168130b106a0cb749a1043943c23b6b/chacha20poly1305_reuseable-0.13.2.tar.gz"
    sha256 "dd8be876e25dfc51909eb35602b77a76e0d01a364584756ab3fa848e2407e4ec"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/5e/d0/ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051b/ecdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
  end

  resource "esphome-dashboard" do
    url "https://files.pythonhosted.org/packages/d4/1b/65ccbe1bccfe3c9750f63ce4fd1f626bccbbc3d07c2c8cff01849e46bb7b/esphome_dashboard-20240620.0.tar.gz"
    sha256 "971de2f19d8f51e7f289b08d890e333c4c1f817afaaff4d56bd4c1174604e5f0"
  end

  resource "esptool" do
    url "https://files.pythonhosted.org/packages/1b/8b/f0d1e75879dee053874a4f955ed1e9ad97275485f51cb4bc2cb4e9b24479/esptool-4.7.0.tar.gz"
    sha256 "01454e69e1ef3601215db83ff2cb1fc79ece67d24b0e5d43d451b410447c4893"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "icmplib" do
    url "https://files.pythonhosted.org/packages/6d/78/ca07444be85ec718d4a7617f43fdb5b4eaae40bc15a04a5c888b64f3e35f/icmplib-3.0.4.tar.gz"
    sha256 "57868f2cdb011418c0e1d5586b16d1fabd206569fe9652654c27b6b2d6a316de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "kconfiglib" do
    url "https://files.pythonhosted.org/packages/86/82/54537aeb187ade9b609af3d2988312350a7fab2ff2d3ec0230ae0410dc9e/kconfiglib-13.7.1.tar.gz"
    sha256 "a2ee8fb06102442c45965b0596944f02c2a1517f092fa208ca307f3fd12a0a22"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/70/40/faa10dc4500bca85f41ca9d8cefab282dd23d0fcc7a9b5fab40691e72e76/marshmallow-3.22.0.tar.gz"
    sha256 "4972f529104a220bb8637d595aa4c9762afbe7f7a77d82dc58c1615d70c5823e"
  end

  resource "noiseprotocol" do
    url "https://files.pythonhosted.org/packages/76/17/fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95/noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "paho-mqtt" do
    url "https://files.pythonhosted.org/packages/f8/dd/4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12/paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "platformio" do
    url "https://files.pythonhosted.org/packages/32/a0/4b1d18da2668a37b28beff3ecdc934940516302565c31a4cd4e17661a285/platformio-6.1.16.tar.gz"
    sha256 "79387b45ca7df9c0c51cae82b3b0a40ba78d11d87cea385db47e1033d781e959"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/b1/a4/4579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549/protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/88/56/0f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0/pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/83/08/13f3bce01b2061f2bbd582c9df82723de943784cf719a35ac886c652043a/pyparsing-3.1.4.tar.gz"
    sha256 "f86ec8d1a83f11977c9a6ea7598e8c27fc5cddfa5b07ea2241edbbde1d7bc032"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/f7/61/a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5e/reedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/61/b5/6bceb93ff20bd7ca36e6f7c540581abb18f53130fabb30ba526e26fd819b/starlette-0.37.2.tar.gz"
    sha256 "9af890290133b79fc3db55474ade20f6220a364a0402e0b556e7cd5e1e093823"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/bd/a2/ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2/tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/e1/34/943888654477a574a86a98e9896bae89c7aa15078ec29f490fef2f1e5384/tzdata-2024.2.tar.gz"
    sha256 "7d85cc416e9382e69095b7bdf4afd9e3880418a2413feec7069d533d6b4e31cc"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/49/8d/5005d39cd79c9ae87baf7d7aafdcdfe0b13aa69d9a1e3b7f1c984a2ac6d2/uvicorn-0.29.0.tar.gz"
    sha256 "6a69214c0b6a087462412670b3ef21224fa48cae0e452b5883e8e8bdfdd11dd0"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/a1/ce/0733e4d6f870a0e5f4dbb00766b36b71ee0d25f8de33d27fb662f29154b1/voluptuous-0.14.2.tar.gz"
    sha256 "533e36175967a310f1b73170d091232bf881403e4ebe52a9b4ade8404d151f5d"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/24/7d/02e8c583b57692eee495e60c7a4dd862635a9702067d69c6dd1c907cb589/zeroconf-0.132.2.tar.gz"
    sha256 "9ad8bc6e3f168fe8c164634c762d3265c775643defff10e26273623a12d73ae1"
  end

  # patch pyyaml and platformio to build with py3.13
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      esphome:
        name: test
        platform: ESP8266
        board: d1
    EOS

    assert_includes shell_output("#{bin}/esphome config #{testpath}/test.yaml 2>&1"), "INFO Configuration is valid!"
    return if Hardware::CPU.arm?

    ENV.remove_macosxsdk if OS.mac?
    system bin/"esphome", "compile", "test.yaml"
  end
end

__END__
diff --git a/PKG-INFO b/PKG-INFO
index b42efb7..74aef15 100644
--- a/PKG-INFO
+++ b/PKG-INFO
@@ -26,7 +26,7 @@ License-File: LICENSE
 Requires-Dist: async_timeout==4.0.3; python_version <= "3.10"
 Requires-Dist: cryptography==43.0.0
 Requires-Dist: voluptuous==0.14.2
-Requires-Dist: PyYAML==6.0.1
+Requires-Dist: PyYAML==6.0.2
 Requires-Dist: paho-mqtt==1.6.1
 Requires-Dist: colorama==0.4.6
 Requires-Dist: icmplib==3.0.4
@@ -34,7 +34,7 @@ Requires-Dist: tornado==6.4
 Requires-Dist: tzlocal==5.2
 Requires-Dist: tzdata>=2021.1
 Requires-Dist: pyserial==3.5
-Requires-Dist: platformio==6.1.15
+Requires-Dist: platformio==6.1.16
 Requires-Dist: esptool==4.7.0
 Requires-Dist: click==8.1.7
 Requires-Dist: esphome-dashboard==20240620.0
diff --git a/requirements.txt b/requirements.txt
index 3e658de..84605e2 100644
--- a/requirements.txt
+++ b/requirements.txt
@@ -1,7 +1,7 @@
 async_timeout==4.0.3; python_version <= "3.10"
 cryptography==43.0.0
 voluptuous==0.14.2
-PyYAML==6.0.1
+PyYAML==6.0.2
 paho-mqtt==1.6.1
 colorama==0.4.6
 icmplib==3.0.4
@@ -9,7 +9,7 @@ tornado==6.4
 tzlocal==5.2    # from time
 tzdata>=2021.1  # from time
 pyserial==3.5
-platformio==6.1.15  # When updating platformio, also update Dockerfile
+platformio==6.1.16  # When updating platformio, also update Dockerfile
 esptool==4.7.0
 click==8.1.7
 esphome-dashboard==20240620.0
