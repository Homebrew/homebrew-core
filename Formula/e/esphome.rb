class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32/ESP8266 super easy"
  homepage "https://github.com/esphome/esphome"
  url "https://files.pythonhosted.org/packages/12/1a/a6653acc001531c63734c9653db5bd30868c557a37febe69cbe1bd7819a7/esphome-2024.9.1.tar.gz"
  sha256 "dcc9de58dcb6b33268ddaeab4b78885063e8be35f6d8fa6a9af701855ee25b40"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "441f323aff756991b3832ecfc6546d9ca28125e64529dd608b73282eb9f273d0"
    sha256 cellar: :any,                 arm64_sonoma:  "3a895130e7afe219d62af822da8a2dfc120a70524818789b3eab714164820528"
    sha256 cellar: :any,                 arm64_ventura: "d8700d80e365b27ddb5e20a941a1ab2a47b2f1c9c90a62fb0016859da51d1f52"
    sha256 cellar: :any,                 sonoma:        "30e3f206e38f99adb231f4257a140887f5542e3bcb656712aa3ac446840c67e9"
    sha256 cellar: :any,                 ventura:       "89b9ab53bc7774bad67a13d0f3e2d85f46a0e56b990707b930d3baef90097d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cfaa45b01dcdfac2d5486319d839253e830c0a5a2e85e5be11b071a18ef4576"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libmagic"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "aioesphomeapi" do
    url "https://files.pythonhosted.org/packages/89/4d/e5b6826e7256abc0783876a382797fd26b632b860eecc61698abb46a52ca/aioesphomeapi-24.6.2.tar.gz"
    sha256 "dfde91df6b115cddac95d82ca968847a7f726b2a0d0ecef6cee8c065bdbb701c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/2d/f7/22bba300a16fd1cad99da1a23793fe43963ee326d012fdf852d0b4035955/aiohappyeyeballs-2.4.0.tar.gz"
    sha256 "55a1714f084e63d49639800f95716da97a1f173d46a16dfcfda0016abb93b6b2"
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
    url "https://files.pythonhosted.org/packages/75/33/a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6/argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  end

  resource "async-interrupt" do
    url "https://files.pythonhosted.org/packages/ef/7c/5a2d74465037b33ccdaf830e3d9ac008bccdbe4b0657983b90dc89191626/async_interrupt-1.2.0.tar.gz"
    sha256 "d147559e2478501ad45ea43f52df23b246456715a7cb96e1aebdb4b71aed43d5"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/c7/bf/25cf92a83e1fe4948d7935ae3c02f4c9ff9cb9c13e977fba8af11a5f642c/bitarray-2.9.2.tar.gz"
    sha256 "a8f286a51a32323715d77755ed959f94bef13972e9a2fe71b609e40e6d27957e"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/d8/d0/d6f57409bb50f54fe2894ec5a50b5c04cb41aa814c3bdb8a7eeb4a0f7697/bitstring-4.2.3.tar.gz"
    sha256 "e0c447af3fda0d114f77b88c2d199f02f97ee7e957e6d719f40f41cf15fbb897"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "chacha20poly1305-reuseable" do
    url "https://files.pythonhosted.org/packages/c1/ff/6ca12ab8f4d804cfe423e67d7e5de168130b106a0cb749a1043943c23b6b/chacha20poly1305_reuseable-0.13.2.tar.gz"
    sha256 "dd8be876e25dfc51909eb35602b77a76e0d01a364584756ab3fa848e2407e4ec"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/13/78/8903f4f505a393ee48a18a00b4b9c866a726ef844d23ff3ce4863d710898/platformio-6.1.15.tar.gz"
    sha256 "d3209a60d40340fdbab2c76ee23303d90e5ecea0a11f92980c9d2068d0975fde"
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
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
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
    url "https://files.pythonhosted.org/packages/74/5b/e025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717/tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
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

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https://sourceforge.net/p/ruamel-yaml-clib/tickets/32/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

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
