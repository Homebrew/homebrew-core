class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/72/72/55b57dadba2f63b0b6c30ebaceb62b56e33643cb22a66a58ec64eeedc745/dvc-1.11.12.tar.gz"
  sha256 "aa419a0174fc7bc104dedd08017eef045e3e82e51c0ee4755f284117737b4d30"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "c2559f8df6043a3f1ce463f350ebc2ed397c3d15d204f27487bd606192c66322" => :big_sur
    sha256 "dae2e3e770d8fdcbf0647f35d0e0c39bc316e9dd422ff9a1980383f32076df43" => :catalina
    sha256 "8dde2b3d2be61df95156dba6d4d79deb28ebb082b7660bc19c024f0eabcb0054" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/ee/b6/5ed5e4eb3147ec1e419d8a32b56d3387aa4334eded304d237d38eeadcb35/atpublic-2.1.2.tar.gz"
    sha256 "82a2f2c0343ac67913f67cdee8fa4da294a4d6b863111527a459c8e4d1a646c8"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/08/bf/9e878ffc50cbe57b63b46dee9f7689c8e1d6fa1c6b65f18a582c3e1a5ebd/dictdiffer-0.8.1.tar.gz"
    sha256 "1adec0d67cdf6166bda96ae2934ddb5e54433998ceab63c984574d187cc563d2"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/60/3f/562b045ad2542ab1279bbc5a05a62511c1ea1d8b5987fb0a50ee78704621/dpath-2.0.1.tar.gz"
    sha256 "bea06b5f4ff620a28dfc9848cf4d6b2bfeed34238edeb8ebe815c433b54eb1fa"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/23/e1/38f2fa20d223c635c8f9a939e45ad6c06d55a7f867c013ee98cf250fb262/dulwich-0.20.15.tar.gz"
    sha256 "fb1773373ec2af896031f8312af6962a1b8b0176a2de3fb3d84a84ec04498888"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/7b/1c/52ee230b2008fd552e1b130d2696e98559ce9e2087fb49394bf71d23df3b/flatten-dict-0.3.0.tar.gz"
    sha256 "0ccc43f15c7c84c5ef387ad19254f6769a32d170313a1bcbf4ce582089313d7e"
  end

  resource "flufl.lock" do
    url "https://files.pythonhosted.org/packages/1e/68/393c148df629f90a919de653ebb967a8bd8c83d07d2bc3150ca0faff3940/flufl.lock-3.2.tar.gz"
    sha256 "a8d66accc9ab41f09961cd8f8db39f9c28e97e2769659a3567c63930a869ff5b"
  end

  resource "ftfy" do
    url "https://files.pythonhosted.org/packages/ff/e2/3b51c53dffb1e52d9210ebc01f1fb9f2f6eba9b3201fa971fd3946643c71/ftfy-5.8.tar.gz"
    sha256 "51c7767f8c4b47d291fcef30b9625fb5341c06a31e6a3b627039c706c42f3720"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/f0/50/f1a9e03bdb6935c77377d2e8762d9876b49b140825b8ac25131245e774f4/funcy-1.15.tar.gz"
    sha256 "65b746fed572b392d886810a98d56939c6e0d545abb750527a717c21ced21008"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/d1/05/eaf2ac564344030d8b3ce870b116d7bb559020163e80d9aa4a3d75f3e820/gitdb-4.0.5.tar.gz"
    sha256 "c9e1f2d0db7ddb9a704c2a0217be31214e91a4fe1dea1efad19ae42ba0c285c9"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ec/4d/e6553122c85ec7c4c3e702142cc0f5ed02e5cf1b4d7ecea86a07e45725a0/GitPython-3.1.12.tar.gz"
    sha256 "42dbefd8d9e2576c496ed0059f3103dcef7125b9ce16f9d5f9c834aed44a1dac"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/a2/3f/df0618a962a1744e932f2a4547cb786f5a93df7e2476c99e7f7dbd68039f/grandalf-0.6.tar.gz"
    sha256 "7471db231bd7338bc0035b16edf0dc0c900c82d23060f4b4d0c4304caedda6e4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/c5/d0/c4b2fa7e00e69670a92b103761b4e10a4bdaca109818d44753219c20b7be/jsonpath-ng-1.5.2.tar.gz"
    sha256 "144d91379be14d9019f51973bd647719c877bfc07dc6f3f5068895765950c69d"
  end

  resource "mailchecker" do
    url "https://files.pythonhosted.org/packages/5a/0d/513e57bf531843ea4613fec8b6843c3b44d57307c9e4d815875f79329d9c/mailchecker-4.0.3.tar.gz"
    sha256 "00dbe9739c754366233eb3887c5deef987672482a26e814314c3e749fc7b1d1f"
  end

  resource "nanotime" do
    url "https://files.pythonhosted.org/packages/d5/54/6d5924f59cf671326e7809f4b3f70fa8df535d67e952ad0b6fea02f52faf/nanotime-0.5.2.tar.gz"
    sha256 "c7cc231fc5f6db401b448d7ab51c96d0a4733f4b69fabe569a576f89ffdf966b"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/ef/d0/f706a9e5814a42c544fa1b2876fc33e5d17e1f2c92a5361776632c4f41ab/networkx-2.5.tar.gz"
    sha256 "7978955423fbc9639c10498878be59caf99b44dc304c2286162fd24b458c1602"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/c5/e81b9fb8033fe78a2355ea7b1774338e1dca2c9cbd2ee140211a9e6291ab/packaging-20.8.tar.gz"
    sha256 "78598185a7008a470d64526a8059de9aaa449238f280fc9eb6b13ba6c4109093"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/94/d8/65c86584e7e97ef824a1845c72bbe95d79f5b306364fa778a3c3e401b309/pathlib2-2.3.5.tar.gz"
    sha256 "6cd9a47b597b37cc57de1c05e56fb1a1c9cc9fab04fe78c29acd090418529868"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/b7/64/e097eea8dcd2b2f7df6e4425fc98e7494e37b1a6e149603c31d327080a05/pathspec-0.8.1.tar.gz"
    sha256 "86379d6b86d75816baba717e64b1a3a3469deb93bb76d613c9ce79edc5cb68fd"
  end

  resource "phonenumbers" do
    url "https://files.pythonhosted.org/packages/ed/10/6e8e0ab7535a54b69793d7ea7f7b1d80262f2ebc3c10bed29f1118d54a17/phonenumbers-8.12.16.tar.gz"
    sha256 "a820ab08c980ef24a2d2a1ead4f8d7016fdf008e484d1aecf7ff0b32cc475e16"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/5f/e2/23e053ccf5648153959ea15d77fb90adb2b1f9c9360f832f39d6d6c024e2/pydot-1.4.1.tar.gz"
    sha256 "d49c9d4dd1913beec2a997f831543c8cbd53e535b1a739e921642fe416235f01"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e1/86/8059180e8217299079d8719c6e23d674aadaba0b1939e25e0cc15dcf075b/Pygments-2.7.4.tar.gz"
    sha256 "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/18/41/2e5cefc895a32d9ca0f3574bd0df09e53a697023579a93582bedc4eeac4d/pygtrie-2.3.2.tar.gz"
    sha256 "6299cdedd2cbdfda0895c2dbc43efe8828e698c62b574f3ef7e14b3253f80e23"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-benedict" do
    url "https://files.pythonhosted.org/packages/13/2e/f799845699100d1ea31fa190dc7322782ad960554c90085f89871f829014/python-benedict-0.23.2.tar.gz"
    sha256 "b7bdffd92ba1c9b9e044bda08ed545a48a45bd7a5207f93b4b2a8eb2660d1b4c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-fsutil" do
    url "https://files.pythonhosted.org/packages/27/56/9aab18bd4769d515b49e9e3fcf827264bc131b36fa73212753cd5575e0a1/python-fsutil-0.4.0.tar.gz"
    sha256 "873eceb11fb488fc2d7675cd1bc74a743502f674f0be88f5e7b920c7baeefed6"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/9f/42/e336f96a8b6007428df772d0d159b8eee9b2f1811593a4931150660402c0/python-slugify-4.0.1.tar.gz"
    sha256 "69a517766e00c1268e5bbfc0d010a0a8508de0b18d30ad5a1ff357f8ae724270"
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
    url "https://files.pythonhosted.org/packages/5a/2d/5e92c69f971cb2a373a5203fe2ff0a06751b3eea918c709318e19f7caf62/rich-9.9.0.tar.gz"
    sha256 "0bd8f42c3a03b7ef5e311d5e37f47bea9d268f541981c169072be5869c007957"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/17/2f/f38332bf6ba751d1c8124ea70681d2b2326d69126d9058fbd9b4c434d268/ruamel.yaml-0.16.12.tar.gz"
    sha256 "076cc0bc34f1966d920a49f18b52b6ad559fbe656a0748e3535cf7b3f29ebf9e"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/6f/e0/a881ca1332e9195acb4c2b912d58a4278f6950e118b628188e2bc8830589/shortuuid-1.0.1.tar.gz"
    sha256 "3c11d2007b915c43bee3e10625f068d8a349e04f0d81f08f5fa08507427ebf1f"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/99/63/0100420a832f176285f28cef3aa2bd6ef249dd2e66a00601019630c5f4fe/shtab-1.3.4.tar.gz"
    sha256 "353f2a3a5178cd2df8eb746e7ab26a5039a9989e4386de8fd239d8c1653a8887"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/2b/6f/d48bbed5aa971943759f4ede3f12dca40aa7faa44f22bad483de86780508/smmap-3.0.5.tar.gz"
    sha256 "84c2751ef3072d4f6b2785ec7ee40244c6f45eb934d9e543e2c51f1bd3d54c50"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/69/50/9f29874d835945b845812799edc732ba30c41e9d20431f9f69c8ffb9c670/tqdm-4.56.0.tar.gz"
    sha256 "fe3d08dd00a526850568d542ff9de9bbc2a09a791da3c334f3213d8d0bbbca65"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/17/0d/6e1e3ab6653720903efd7f644cc5be839d59ceb396143c08c1bebeab080b/voluptuous-0.12.1.tar.gz"
    sha256 "663572419281ddfaf4b4197fd4942d181630120fb39b333e3adad70aeb56444b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  resource "zc.lockfile" do
    url "https://files.pythonhosted.org/packages/11/98/f21922d501ab29d62665e7460c94f5ed485fd9d8348c126697947643a881/zc.lockfile-2.0.tar.gz"
    sha256 "307ad78227e48be260e64896ec8886edc7eae22d8ec53e4d528ab5537a83203b"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")

    # NOTE: pyarrow is already installed as a part of apache-arrow package,
    # so we don't need to specify `hdfs` option.
    extras = %w[gs s3 azure ssh gdrive webdav]

    if MacOS.version <= :big_sur
      # NOTE: currently unable to build pycryptodome dependency for oss.
      # See https://github.com/Homebrew/homebrew-core/pull/66130
      extras << "oss"
    end

    system libexec/"bin/pip", "install",
      "--no-binary", ":all:",
      # NOTE: we will uninstall Pillow anyway, so there is no need to build it
      # from source.
      "--only-binary", "Pillow",
      "--ignore-installed",
      ".[#{extras.join(",")}]"

    # NOTE: dvc depends on asciimatics, which depends on Pillow, which
    # uses liblcms2.2.dylib that causes troubles on mojave. See [1]
    # and [2] for more info. As a workaround, we need to simply
    # uninstall Pillow.
    #
    # [1] https://github.com/peterbrittain/asciimatics/issues/95
    # [2] https://github.com/iterative/homebrew-dvc/issues/9
    system libexec/"bin/pip", "uninstall", "-y", "Pillow"
    system libexec/"bin/pip", "uninstall", "-y", "dvc"

    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/0.68.1/dvc/utils/pkg.py
    File.open("dvc/utils/build.py", "w+") { |file| file.write("PKG = \"brew\"") }

    venv.pip_install_and_link buildpath

    (bash_completion/"dvc").write `#{bin}/dvc completion -s bash`
    (zsh_completion/"_dvc").write `#{bin}/dvc completion -s zsh`
  end

  test do
    system "#{bin}/dvc", "version"
  end
end
