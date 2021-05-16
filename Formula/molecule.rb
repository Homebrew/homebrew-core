class Molecule < Formula
  include Language::Python::Virtualenv

  desc "Automated testing for Ansible roles"
  homepage "https://molecule.readthedocs.io"
  url "https://files.pythonhosted.org/packages/c4/b9/87a02077d873ccee6e5b72077aaf851f8614c098776e558aa10b31373309/molecule-3.3.1.tar.gz"
  sha256 "9ac0fde11f895bbc6727de26e2ab0bd0316964f4e4facfd821240959814f9572"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c21ab8a2df0777de6784092b2c2f24b46d3d692f33d9f2e133a6f75ee4fed748"
    sha256 cellar: :any, big_sur:       "fbf863a676eb9512379942aa64e31b6c3b10ae05d03588164fcb3ade922df05d"
    sha256 cellar: :any, catalina:      "7db8cbd2e5acfa8d9adb20b3414a2af7d56d728575a684b1b18afb666c43d148"
    sha256 cellar: :any, mojave:        "d6a608eb95bfd16ff30c1b0ea4cfd2f9eb06d0c03664e739e2fee65d9394784b"
  end

  depends_on "rust" => :build
  depends_on "ansible"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gmp"
  end

  # Instructions for updating the resource blocks:
  # 1. Run `brew update-python-resources molecule --extra-packages docker-py,python-vagrant`
  # 2. Manually re-add the `molecule-vagrant` resource using the link and checksum found at
  #    `https://pypi.org/project/molecule-vagrant/#files`

  resource "molecule-vagrant" do
    url "https://files.pythonhosted.org/packages/2d/95/70a098aca889beb3c44c7943367ca9f63838f18cbfc5060d512a41104d6b/molecule-vagrant-0.6.3.tar.gz"
    sha256 "c1d7f8def1cf8878f52e40de50bbe93d804e87859e01d27dcf81c1e84c164782"
  end

  resource "ansible-lint" do
    url "https://files.pythonhosted.org/packages/56/ac/726a486e7a6118c701dfdd6d04a7b745c24fbb79da07b16a453cc737aaad/ansible-lint-5.0.8.tar.gz"
    sha256 "b67b9628407ae9bc15bb0bb71f79871bdf593fefe6b0684c0cc44be5fc90803f"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/0a/97/e58a3cd2207cb9cb7aa9b91f3bc4df3b4e13eafc88d75b1a9f4535ea6e1f/arrow-1.1.0.tar.gz"
    sha256 "b8fe13abf3517abab315e09350c903902d1447bd311afbc17547ba1cb3ff5bd8"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/bb/80/7118945282845f8dc337c45c7d9d171a9f86d0c7650ac7e65d60995691d2/bracex-2.1.1.tar.gz"
    sha256 "01f715cd0ed7a622ec8b32322e715813f7574de531f09b70f6f3b2c10f682425"
  end

  resource "Cerberus" do
    url "https://files.pythonhosted.org/packages/c4/87/55f8b2e36a5f97c5aaf6424e75f7a21cbd69d0365f6e2e332d03d029bb15/Cerberus-1.3.4.tar.gz"
    sha256 "d1b21b3954b2498d9a79edf16b3170a3ac1021df88d197dc2ce5928ba519237c"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/d5/99/286fd2fdfb501620a9341319ba47444040c7b3094d3b6c797d7281469bf8/click-8.0.0.tar.gz"
    sha256 "7d8c289ee437bcb0316820ccee14aefcb056e58d31830ecab8e47eda6540e136"
  end

  resource "click-completion" do
    url "https://files.pythonhosted.org/packages/93/18/74e2542defdda23b021b12b835b7abbd0fc55896aa8d77af280ad65aa406/click-completion-0.5.2.tar.gz"
    sha256 "5bf816b81367e638a190b6e91b50779007d14301b3f9f3145d68e3cade7bce86"
  end

  resource "click-help-colors" do
    url "https://files.pythonhosted.org/packages/f2/bc/59845c80c99d77321c3271a941b616cbdfd7a3602647532150d14e95e93d/click-help-colors-0.9.tar.gz"
    sha256 "eb037a2dd95a9e20b3897c2b3ca57e7f6797f76a8d93f7eeedda7fcdcbc9b635"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/58/f5/6f41fa38e6efe4a0e85771f99a4ad8c33b4c14f03b4cc53b459aac4a629a/cookiecutter-1.7.3.tar.gz"
    sha256 "6b9a4d72882e243be077a7397d0f1f76fe66cf3df91f3115dbb5330e214fa457"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/fa/2d/906afc44a833901fc6fed1a89c228e5c88fbfc6bd2f3d2f0497fdfb9c525/docker-py-1.10.6.tar.gz"
    sha256 "4c2a75875764d38d67f87bc7d03f7443a3895704efc57962bdf6500b8d4bc415"
  end

  resource "docker-pycreds" do
    url "https://files.pythonhosted.org/packages/c5/e6/d1f6c00b7221e2d7c4b470132c931325c8b22c51ca62417e300f5ce16009/docker-pycreds-0.4.0.tar.gz"
    sha256 "6ce3270bcaf404cc4c3e27e4b6c70d3521deae82fb508767870fdbf772d584d4"
  end

  resource "enrich" do
    url "https://files.pythonhosted.org/packages/47/2b/b453d52a5cd1409d859d67c6a530971095406aedc0c0589c1c6a5212f506/enrich-1.2.6.tar.gz"
    sha256 "0e99ff57d87f7b5def0ca79917e88fb9351aa0d52e228ee38bff7cd858315fe4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/0c/23cbcf515b5394e9f59a3e6629f26e1142b92d474ee0725a26aa5a3bcf76/Jinja2-3.0.0.tar.gz"
    sha256 "ea8d7dd814ce9df6de6a761ec7f1cac98afe305b8cdc4aaae4e114b8d8ce24c5"
  end

  resource "jinja2-time" do
    url "https://files.pythonhosted.org/packages/de/7c/ee2f2014a2a0616ad3328e58e7dac879251babdb4cb796d770b5d32c469f/jinja2-time-0.2.0.tar.gz"
    sha256 "d14eaa4d315e7688daa4969f616f226614350c48730bfa1692d2caebd8c90d40"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/67/6a/5b3ed5c122e20c33d2562df06faf895a6b91b0a6b96a4626440ffe1d5c8e/MarkupSafe-2.0.0.tar.gz"
    sha256 "4fae0677f712ee090721d8b17f412f1cbceefbf0dc180fe91bab3232f38b4527"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "poyo" do
    url "https://files.pythonhosted.org/packages/7d/56/01b496f36bbd496aed9351dd1b06cf57fd2f5028480a87adbcf7a4ff1f65/poyo-0.5.0.tar.gz"
    sha256 "e26956aa780c45f011ca9886f044590e2d8fd8b61db7b1c1cf4e0869f48ed4dd"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/bc/a4/57893fbaf7cbf303a4f2307564cf83855a5f2cc34544656e7263125a0d1e/python-slugify-5.0.2.tar.gz"
    sha256 "f13383a0b9fcbe649a1892b9c8eb4f8eab1d6d84b84bb7a624317afa98159cab"
  end

  resource "python-vagrant" do
    url "https://files.pythonhosted.org/packages/bb/c6/0a6d22ae1782f261fc4274ea9385b85bf792129d7126575ec2a71d8aea18/python-vagrant-0.5.15.tar.gz"
    sha256 "af9a8a9802d382d45dbea96aa3cfbe77c6e6ad65b3fe7b7c799d41ab988179c6"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ad/71/849f1bb4d11d5d47756e76e3d0d41970dc5134b3d6e02af224d56a4913b8/rich-10.2.0.tar.gz"
    sha256 "a30429d82363d42e7c64e324c2c8735c045f190cba609feee91a7b9f563a64b5"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/62/cf/148028462ab88a71046ba0a30780357ae9e07125863ea9ca7808f1ea3798/ruamel.yaml-0.17.4.tar.gz"
    sha256 "44bc6b54fddd45e4bc0619059196679f9e8b79c027f4131bb072e6a22f4d5e28"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/79/2a/cc70df8ca362c39fe5ad84e9cd175f886bf65a68a697778e8a9935770e45/subprocess-tee-0.3.1.tar.gz"
    sha256 "518b59a4cd51573749c8f063a675ff9b4ee3370742ee1d7078c2a8b73bad2567"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/9e/ff/65d44f70e9a5273b6185ccbff194bb649e4fa6bd328113feda964f277f2d/tenacity-7.0.0.tar.gz"
    sha256 "5bd16ef5d3b985647fe28dfa6f695d343aa26479a04e8792b9d3c8f49e361ae1"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/24/b9/51525e9aea08d04e602a53812afe3890e78d204e55464f8d0ea906587e54/wcmatch-8.1.2.tar.gz"
    sha256 "efda751de15201b395b6d6e64e6ae3b6b03dc502a64c3c908aa5cad14c27eee5"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/48/bf/c706b56243f1641159ff211b51d3341024e1cdf63defc2b74595b6319039/websocket-client-0.59.0.tar.gz"
    sha256 "d376bd60eace9d437ab6d7ee16f4ab4e821c9dae591e1b783c58ebd8aaf80c5c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Test the Vagrant driver
    system bin/"molecule", "init", "role", "foo-vagrant", "--driver-name",
                           "vagrant", "--verifier-name", "testinfra"
    assert_predicate testpath/"foo-vagrant/molecule/default/molecule.yml", :exist?,
                     "Failed to create 'foo-vagrant/molecule/default/molecule.yml' file!"
    assert_predicate testpath/"foo-vagrant/molecule/default/tests/test_default.py", :exist?,
                     "Failed to create 'foo-vagrant/molecule/default/tests/test_default.py' file!"
    cd "foo-vagrant" do
      system bin/"molecule", "list"
    end
  end
end
