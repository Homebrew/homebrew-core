class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32/ESP8266 super easy"
  homepage "https://github.com/esphome/esphome"
  url "https://files.pythonhosted.org/packages/ad/8c/6e0018f5b398e18cc83f17509086334adc8c8feebe6718566409184c4973/esphome-2024.12.4.tar.gz"
  sha256 "3ae784dd8059e50244e2f5bd3f5d9f5b9a460063fab4fdd0404d602b6620e217"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb0af02acaede1c70f73d78a525630b3dd694672848639f553cee31382848271"
    sha256 cellar: :any,                 arm64_sonoma:  "b67af9d6bb4c5a5723dea079b1eeae3bfd7b11e089190aa323aaa5f8f1c391fe"
    sha256 cellar: :any,                 arm64_ventura: "7a341338b02133ef94bf6f018f496c10d0bfaaed417b5abfd00843c431ceb9ca"
    sha256 cellar: :any,                 sonoma:        "5d9bce7bea6a323b33e350df13c83e9ca9d1be6c51d66815cec469f831137be4"
    sha256 cellar: :any,                 ventura:       "3acdd2e1e7853c7e5680a311ad13ca1a5fcb299488a322d1dd90dc9d4be8ba35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd7de1ab7d4afb96fdb7a865c2f30ec4481901492e7c38a77c12908fea1faba3"
  end

  depends_on "pkgconf" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libmagic"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libyaml"
  depends_on "little-cms2"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "webp"

  uses_from_macos "zlib"

  resource "aioesphomeapi" do
    url "https://files.pythonhosted.org/packages/89/4d/e5b6826e7256abc0783876a382797fd26b632b860eecc61698abb46a52ca/aioesphomeapi-24.6.2.tar.gz"
    sha256 "dfde91df6b115cddac95d82ca968847a7f726b2a0d0ecef6cee8c065bdbb701c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/7f/55/e4373e888fdacb15563ef6fa9fa8c8252476ea071e96fb46defac9f18bf2/aiohappyeyeballs-2.4.4.tar.gz"
    sha256 "5fdd7d87889c63183afc18ce9271f9b0a7d32c2303e394468dd45d514a757745"
  end

  resource "ajsonrpc" do
    url "https://files.pythonhosted.org/packages/da/5c/95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1/ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a3/73/199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cde/anyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0c/be/6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597/argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  end

  resource "async-interrupt" do
    url "https://files.pythonhosted.org/packages/ef/7c/5a2d74465037b33ccdaf830e3d9ac008bccdbe4b0657983b90dc89191626/async_interrupt-1.2.0.tar.gz"
    sha256 "d147559e2478501ad45ea43f52df23b246456715a7cb96e1aebdb4b71aed43d5"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/48/c8/6260f8ccc11f0917360fc0da435c5c9c7504e3db174d5a12a1494887b045/attrs-24.3.0.tar.gz"
    sha256 "8f5c07333d543103541ba7be0e2ce16eeee8130cb0b3f9238ab904ce1e85baff"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/85/62/dcfac53d22ef7e904ed10a8e710a36391d2d6753c34c869b51bfc5e4ad54/bitarray-3.0.0.tar.gz"
    sha256 "a2083dc20f0d828a7cdf7a16b20dae56aab0f43dc4f347a3b3039f6577992b03"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/0d/43/52859178f337661e2d496262f9061799d99644012b7b02ab5d7c491c21fd/bitstring-4.3.0.tar.gz"
    sha256 "81800bc4e00b6508716adbae648e741256355c8dfd19541f76482fb89bee0313"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/1b/fb/97839b95c2a2ea1ca91877a846988f90f4ca16ee42c0bb79e079171c0c06/bottle-0.13.2.tar.gz"
    sha256 "e53803b9d298c7d343d00ba7d27b0059415f04b9f6f40b8d58b5bf914ba9d348"
  end

  resource "chacha20poly1305-reuseable" do
    url "https://files.pythonhosted.org/packages/c1/ff/6ca12ab8f4d804cfe423e67d7e5de168130b106a0cb749a1043943c23b6b/chacha20poly1305_reuseable-0.13.2.tar.gz"
    sha256 "dd8be876e25dfc51909eb35602b77a76e0d01a364584756ab3fa848e2407e4ec"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "defcon" do
    url "https://files.pythonhosted.org/packages/7a/9e/ebce8d0eec62c7e6c676bf2e2e39feeafbfe78711355df4a7e5974b2ae06/defcon-0.10.3.zip"
    sha256 "56de26d7c75f164eea03e28bc11b4c769c68d705fa186dfcaeb56c27f9a4cc0c"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/5e/d0/ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051b/ecdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
  end

  resource "esphome-dashboard" do
    url "https://files.pythonhosted.org/packages/39/b5/77fdc0c898903de9b0601ea381653d6add51928a02b563e5548c7d5f4b62/esphome_dashboard-20241217.1.tar.gz"
    sha256 "fc996c6e76dcf41af66cad79f95b8e8c2620920dc49b191a1ff3ac9e4bb2a42a"
  end

  resource "esptool" do
    url "https://files.pythonhosted.org/packages/1b/8b/f0d1e75879dee053874a4f955ed1e9ad97275485f51cb4bc2cb4e9b24479/esptool-4.7.0.tar.gz"
    sha256 "01454e69e1ef3601215db83ff2cb1fc79ece67d24b0e5d43d451b410447c4893"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/76/61/a300d1574dc381393424047c0396a0e213db212e28361123af9830d71a8d/fonttools-4.55.3.tar.gz"
    sha256 "3983313c2a04d6cc1fe9251f8fc647754cf49a61dac6cb1e7249ae67afaafc45"
  end

  resource "freetype-py" do
    url "https://files.pythonhosted.org/packages/d0/9c/61ba17f846b922c2d6d101cc886b0e8fb597c109cedfcb39b8c5d2304b54/freetype-py-2.5.1.zip"
    sha256 "cfe2686a174d0dd3d71a9d8ee9bf6a2c23f5872385cf8ce9f24af83d076e2fbd"
  end

  resource "fs" do
    url "https://files.pythonhosted.org/packages/5d/a9/af5bfd5a92592c16cdae5c04f68187a309be8a146b528eac3c6e30edbad2/fs-2.4.16.tar.gz"
    sha256 "ae97c7d51213f4b70b6a958292530289090de3a7e15841e108fbe144f069d313"
  end

  resource "gflanguages" do
    url "https://files.pythonhosted.org/packages/b3/06/26a486767797b6b0aae0d34c3ddafb5a8ac314569e425bc60b516ba0c0ee/gflanguages-0.7.2.tar.gz"
    sha256 "f1997f52ea5c982e1f17e8f5acb70c1a26f23656c0c2449aa669e428ff4064b3"
  end

  resource "glyphsets" do
    url "https://files.pythonhosted.org/packages/9d/be/d1526237e23f798e6072e552f64da19bd1afe4bf58b3b2b1e626cd6285bf/glyphsets-1.0.0.tar.gz"
    sha256 "7daf96d4818865c9f53f5c4d2a6d586ff4ceb9fe1074356722f94390e2ce70b6"
  end

  resource "glyphslib" do
    url "https://files.pythonhosted.org/packages/87/5d/c69ff84ad33983f95056dfc98e3e0d555d49a54eb5eaebea0468011e3449/glyphslib-6.9.5.tar.gz"
    sha256 "e081c3514d6bc12e62e5c849e1d222ae7607ff7ed58628848a72323e88277c6f"
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
    url "https://files.pythonhosted.org/packages/b8/85/43b8e95251312e8d0d3389263e87e368a5a015db475e140d5dd8cb8dcb47/marshmallow-3.25.1.tar.gz"
    sha256 "f4debda3bb11153d81ac34b0d582bf23053055ee11e791b54b4b35493468040a"
  end

  resource "noiseprotocol" do
    url "https://files.pythonhosted.org/packages/76/17/fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95/noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "openstep-plist" do
    url "https://files.pythonhosted.org/packages/9c/36/edffefa5f2f679fc7c146303c035fc18b015a1c5b7c48b5beb2d53abc2b9/openstep_plist-0.4.0.tar.gz"
    sha256 "453a56cdf534c6f42d24934d2ed7f95bc77c3d1a8acbc1881a4aa061a7d601a2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paho-mqtt" do
    url "https://files.pythonhosted.org/packages/f8/dd/4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12/paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/cd/74/ad3d526f3bf7b6d3f408b73fde271ec69dfac8b81341a318ce825f2b3812/pillow-10.4.0.tar.gz"
    sha256 "166c1cd4d24309b30d61f79f4a9114b7b2313d7450912277855ff5dfd7cd4a06"
  end

  resource "platformio" do
    url "https://files.pythonhosted.org/packages/32/a0/4b1d18da2668a37b28beff3ecdc934940516302565c31a4cd4e17661a285/platformio-6.1.16.tar.gz"
    sha256 "79387b45ca7df9c0c51cae82b3b0a40ba78d11d87cea385db47e1033d781e959"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/d5/ce/dc3a664654f1abed89d4e8a95ac3af02a2a0449c776ccea5ef9f48bde267/puremagic-1.27.tar.gz"
    sha256 "7cb316f40912f56f34149f8ebdd77a91d099212d2ed936feb2feacfc7cbce2c1"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/88/56/0f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0/pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
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

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/02/0a/62fbd5697f6174041f9b4e2e377b6f383f9189b77dbb7d73d24624caca1d/starlette-0.39.2.tar.gz"
    sha256 "caaa3b87ef8518ef913dac4f073dea44e85f73343ad2bdc17941931835b2a26a"
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

  resource "ufolib2" do
    url "https://files.pythonhosted.org/packages/1e/e1/d20226fc36ce7df772500409879c3a856f77a07ba8a5e1629449f219a656/ufolib2-0.17.0.tar.gz"
    sha256 "891524052b3636a25b9a92f13f7fd8c24e15483bac96ccd0245ae947d127248b"
  end

  resource "unicodedata2" do
    url "https://files.pythonhosted.org/packages/8c/c6/f1aa23ed42259789c1c9bdeac219bfe72cc3046c3fc39ad3155705f81d9b/unicodedata2-16.0.0.tar.gz"
    sha256 "05488d6592b59cd78b61ec37d38725416b2df62efafa6a0d63a631b27aa474fc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/5a/01/5e637e7aa9dd031be5376b9fb749ec20b86f5a5b6a49b87fabd374d5fa9f/uvicorn-0.30.6.tar.gz"
    sha256 "4b15decdda1e72be08209e860a1e10e92439ad5b97cf44cc945fcbee66fc5788"
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
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "esphome",
                                         shell_parameter_format: :arg)
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      esphome:
        name: test
        platform: ESP8266
        board: d1
    YAML

    assert_includes shell_output("#{bin}/esphome config #{testpath}/test.yaml 2>&1"), "INFO Configuration is valid!"
    return if Hardware::CPU.arm?

    ENV.remove_macosxsdk if OS.mac?
    system bin/"esphome", "compile", "test.yaml"
  end
end
