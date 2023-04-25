class MetaPackageManager < Formula
  include Language::Python::Virtualenv

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/f5/28/5235fca899ead8059fbb35dd4bd786c1dbd4e1d0d65ae2d136540681a60c/meta_package_manager-5.13.0.tar.gz"
  sha256 "8452718bbcec58dac5fd27691b1be621fcc0d25eb54cb3d3a7db89cfd7f2b1d3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "148c4e61dc29d373535caf5c1bf21f06a07cb1cd3aadda9e1a5f434b1938ab6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70409d719fdf6bc2182492a5290241d8c7b5f49c71d8915decf0b320d683f908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e96233dbd3ebb5fd7272118ddf510f862b471901e507613e7bab8239410b597d"
    sha256 cellar: :any_skip_relocation, ventura:        "c5ccdb0aa24e584a32836c765e2098691b885eaac5c40f81e9cb01b1c36467e3"
    sha256 cellar: :any_skip_relocation, monterey:       "7f0b1802f6976e7193e476fc31c771c295dfae8827dfb970a69d14d059b9fc18"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b45c59e04e1243f59a94bd7a06e1e9ae30a1da23a3552c4c021a745c37bb99b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5312868876a4869c0b1d0adca64af0dfdd3a20f31db4c8ec2839318a6236e94"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/94/71/a8ee96d1fd95ca04a0d2e2d9c4081dac4c2d2b12f7ddb899c8cb9bfd1532/alabaster-0.7.13.tar.gz"
    sha256 "a27a4a084d5e690e16e01e03ad2b2e552c61a65469419b907243193de1a84ae2"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/ff/80/45b42203ecc32c8de281f52e3ec81cb5e4ef16127e9e8543089d8b1649fb/Babel-2.11.0.tar.gz"
    sha256 "5ef4b3226b0180dedded4229651c8b0e1a3a6a2837d45a073272f313e4cf97f6"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/75/f8/de84282681c5a8307f3fff67b64641627b2652752d49d9222b77400d02b8/beautifulsoup4-4.11.2.tar.gz"
    sha256 "bc4bdda6717de5a2987436fb8d72f45dc90dd856bdfd512a1314ce90349a0106"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/e1/13/1a38fd4ee194985cfc674358fcf2ca10a80c5b14fafa62abbb1e6088fcab/boltons-23.0.0.tar.gz"
    sha256 "8c50a71829525835ca3c849c7ed2511610c972b4dddfcd41a4a5447222beb4b0"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "bump2version" do
    url "https://files.pythonhosted.org/packages/29/2a/688aca6eeebfe8941235be53f4da780c6edee05dbbea5d7abaa3aab6fad2/bump2version-1.0.1.tar.gz"
    sha256 "762cb2bfad61f4ec8e2bdf452c7c267416f8c70dd9ecb1653fd0bbb01fa936e6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/06/04/c7c0cb18120e8cb8629c975ae5e118e5b44b2c0cfaa63dc39b45d779e66f/click_extra-3.10.0.tar.gz"
    sha256 "74e7b65c453c6e2d59f87d63f8fa249ede4362851f4cf32f46e0953d472609d6"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/4e/ad/39b9ff9333d89577a36f8cc31ae025855ca62171169947ad5300c2e08ebc/cloup-2.0.0.post1.tar.gz"
    sha256 "1430c9075062e09cb64cd84ab7afe5d5acd28adf561d6ab3109eb1975bbd7b6b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "commentjson" do
    url "https://files.pythonhosted.org/packages/c0/76/c4aa9e408dbacee3f4de8e6c5417e5f55de7e62fb5a50300e1233a2c9cb5/commentjson-0.9.0.tar.gz"
    sha256 "42f9f231d97d93aff3286a4dc0de39bfd91ae823d1d9eba9fa901fe0c7113dd4"
  end

  resource "coverage" do
    url "https://files.pythonhosted.org/packages/54/8a/db9d9cd24f96bb872eea151bb0d5c8cb6a96825b70a0cfaf07bceab2884d/coverage-7.2.2.tar.gz"
    sha256 "36dd42da34fe94ed98c39887b86db9d06777b1c8f860520e21126a75507024f2"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/15/ab/dd27fb742b19a9d020338deb9ab9a28796524081bca880ac33c172c9a8f6/exceptiongroup-1.1.0.tar.gz"
    sha256 "bcb67d800a4497e1b404c2dd44fca47d3b7a5e5433dbab67f96c1a685cdfdf23"
  end

  resource "execnet" do
    url "https://files.pythonhosted.org/packages/7a/3c/b5ac9fc61e1e559ced3e40bf5b518a4142536b34eb274aa50dff29cb89f5/execnet-1.9.0.tar.gz"
    sha256 "8f694f3ba9cc92cab508b152dcfe322153975c29bda272e2fd7f3f00f36e47c5"
  end

  resource "furo" do
    url "https://files.pythonhosted.org/packages/d3/21/233938933f1629a4933c8fce2f803cc8fd211ca563ea4337cb44920bbbfa/furo-2023.3.27.tar.gz"
    sha256 "b99e7867a5cc833b2b34d7230631dd6558c7a29f93071fdbb5709634bb33c5a5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/a7/84/62473fb57d61e31fef6e36d64a179c8781605429fd927b5dd608c997be31/imagesize-1.4.1.tar.gz"
    sha256 "69150444affb9cb0d5cc5a92b3676f0b2fb7cd9ae39e947a5e11a36b4497cd4a"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/07/6397ad02d31bddf1841c9ad3ec30a693a3ff208e09c2ef45c9a8a5f85156/importlib_metadata-6.0.0.tar.gz"
    sha256 "e354bedeb60efa6affdcc8ae121b73544a7aa74156d047311948f6d711cd378d"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "lark-parser" do
    url "https://files.pythonhosted.org/packages/34/b8/aa7d6cf2d5efdd2fcd85cf39b33584fe12a0f7086ed451176ceb7fb510eb/lark-parser-0.7.8.tar.gz"
    sha256 "26215ebb157e6fb2ee74319aa4445b9f3b7e456e26be215ce19fdaaa901c20a4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/25/f5/5b9caa98f480ba38f15236a4049ff7d7a803735081d83d4997b2b12b27d3/mdit-py-plugins-0.3.4.tar.gz"
    sha256 "3278aab2e2b692539082f05e1243f24742194ffd92481f48844f057b51971283"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/62/54/be80f8d01f5cf72f774a77f9f750527a6fa733f09f78b1da30e8fa3914e6/mypy-1.1.1.tar.gz"
    sha256 "ae9ceae0f5b9059f33dbc62dea087e942c0ccab4b7a003719cb70f9b8abfa32f"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "myst-parser" do
    url "https://files.pythonhosted.org/packages/5f/69/fbddb50198c6b0901a981e72ae30f1b7769d2dfac88071f7df41c946d133/myst-parser-1.0.0.tar.gz"
    sha256 "502845659313099542bd38a2ae62f01360e7dd4b1310f025dd014dfc0439cdae"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/91/c7/47a411700a121acc05fe78642b019afe320592078e58c182537c7c65006f/packageurl-python-0.11.1.tar.gz"
    sha256 "bbcc53d2cb5920c815c1626c75992f319bfc450b73893fa7bd8aac5869aa49fe"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "Pallets-Sphinx-Themes" do
    url "https://files.pythonhosted.org/packages/38/46/660bea149d51bd4aa85acb0ab2680e00de95f6164c24706e49f1de1f8242/Pallets-Sphinx-Themes-2.0.3.tar.gz"
    sha256 "54f991c3897f363c757dcba01adb44791609cb02cc7eaac3a5fcdd3d3d9dfeb3"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "pygments-ansi-color" do
    url "https://files.pythonhosted.org/packages/b2/93/af2feb6f3f436a44fbe20c0b6861641ad01f00139d96ae27a2649149bad3/pygments-ansi-color-0.2.0.tar.gz"
    sha256 "8e2f9a57873b4b28d6b95a8f1c9f346be5fc0f9e4f4a316594584a0684aa7959"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/b9/29/311895d9cd3f003dd58e8fdea36dd895ba2da5c0c90601836f7de79f76fe/pytest-7.2.2.tar.gz"
    sha256 "c99ab0c73aceb050f68929bc93af19ab6db0558791c6a0715723abe9d0ade9d4"
  end

  resource "pytest-cov" do
    url "https://files.pythonhosted.org/packages/ea/70/da97fd5f6270c7d2ce07559a19e5bf36a76f0af21500256f005a69d9beba/pytest-cov-4.0.0.tar.gz"
    sha256 "996b79efde6433cdbd0088872dbc5fb3ed7fe1578b68cdbba634f14bb8dd0470"
  end

  resource "pytest-randomly" do
    url "https://files.pythonhosted.org/packages/2e/1c/35f9746b7bd794e205f3a70ae0d6e167d2c929342e15de40d9d37f3b675e/pytest-randomly-3.12.0.tar.gz"
    sha256 "d60c2db71ac319aee0fc6c4110a7597d611a8b94a5590918bfa8583f00caccb2"
  end

  resource "pytest-xdist" do
    url "https://files.pythonhosted.org/packages/e3/f8/de2dcd2938c05270c9881cb1463dea388acd0b239ee76809160420157784/pytest-xdist-3.2.1.tar.gz"
    sha256 "1849bd98d8b242b948e472db7478e090bf3361912a8fed87992ed94085f54727"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/1b/cb/34933ebdd6bf6a77daaa0bd04318d61591452eb90ecca4def947e3cb2165/soupsieve-2.4.tar.gz"
    sha256 "e28dba9ca6c7c00173e34e4ba57448f0688bb681b7c5e8bf4971daafc093d69a"
  end

  resource "Sphinx" do
    url "https://files.pythonhosted.org/packages/af/b2/02a43597980903483fe5eb081ee8e0ba2bb62ea43a70499484343795f3bf/Sphinx-5.3.0.tar.gz"
    sha256 "51026de0a9ff9fc13c05d74913ad66047e104f56a129ff73e174eb5c3ee794b5"
  end

  resource "sphinx-autodoc-typehints" do
    url "https://files.pythonhosted.org/packages/9c/fe/3f7b14afe895f6d3abb168d451c785527489b24cad21c765a59d0f4f4f74/sphinx_autodoc_typehints-1.22.tar.gz"
    sha256 "71fca2d5eee9b034204e4c686ab20b4d8f5eb9409396216bcae6c87c38e18ea6"
  end

  resource "sphinx-basic-ng" do
    url "https://files.pythonhosted.org/packages/80/77/df8674b4c0eb26d5a3817858ec83f103389c7c1ce31f7d31b13394a6ff0e/sphinx_basic_ng-1.0.0b1.tar.gz"
    sha256 "89374bd3ccd9452a301786781e28c8718e99960f2d4f411845ea75fc7bb5a9b0"
  end

  resource "sphinx-click" do
    url "https://files.pythonhosted.org/packages/48/bf/8e5c3e7865d909a64ed2bd89dcc835f3c542fec857c8bdf38ee8b682af14/sphinx-click-4.4.0.tar.gz"
    sha256 "cc67692bd28f482c7f01531c61b64e9d2f069bfcf3d24cbbb51d4a84a749fa48"
  end

  resource "sphinx-copybutton" do
    url "https://files.pythonhosted.org/packages/19/9b/fb86f67989742b077f46b3c979d671b8fac685a23a01c64073f4f6208d27/sphinx-copybutton-0.5.1.tar.gz"
    sha256 "366251e28a6f6041514bfb5439425210418d6c750e98d3a695b73e56866a677a"
  end

  resource "sphinx-design" do
    url "https://files.pythonhosted.org/packages/7b/28/0eb39f87239acf377db5f08cf2f2b27d43c3371624a4cca128dfe952aa10/sphinx_design-0.3.0.tar.gz"
    sha256 "7183fa1fae55b37ef01bda5125a21ee841f5bbcbf59a35382be598180c4cefba"
  end

  resource "sphinx-issues" do
    url "https://files.pythonhosted.org/packages/00/35/a50591c1242d3f3927bcfd0e967c2858fef8fdb50f25b742015b6c841e03/sphinx-issues-3.0.1.tar.gz"
    sha256 "b7c1dc1f4808563c454d11c1112796f8c176cdecfee95f0fd2302ef98e21e3d6"
  end

  resource "sphinxcontrib-applehelp" do
    url "https://files.pythonhosted.org/packages/9f/01/ad9d4ebbceddbed9979ab4a89ddb78c9760e74e6757b1880f1b2760e8295/sphinxcontrib-applehelp-1.0.2.tar.gz"
    sha256 "a072735ec80e7675e3f432fcae8610ecf509c5f1869d17e2eecff44389cdbc58"
  end

  resource "sphinxcontrib-devhelp" do
    url "https://files.pythonhosted.org/packages/98/33/dc28393f16385f722c893cb55539c641c9aaec8d1bc1c15b69ce0ac2dbb3/sphinxcontrib-devhelp-1.0.2.tar.gz"
    sha256 "ff7f1afa7b9642e7060379360a67e9c41e8f3121f2ce9164266f61b9f4b338e4"
  end

  resource "sphinxcontrib-htmlhelp" do
    url "https://files.pythonhosted.org/packages/eb/85/93464ac9bd43d248e7c74573d58a791d48c475230bcf000df2b2700b9027/sphinxcontrib-htmlhelp-2.0.0.tar.gz"
    sha256 "f5f8bb2d0d629f398bf47d0d69c07bc13b65f75a81ad9e2f71a63d4b7a2f6db2"
  end

  resource "sphinxcontrib-jsmath" do
    url "https://files.pythonhosted.org/packages/b2/e8/9ed3830aeed71f17c026a07a5097edcf44b692850ef215b161b8ad875729/sphinxcontrib-jsmath-1.0.1.tar.gz"
    sha256 "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8"
  end

  resource "sphinxcontrib-mermaid" do
    url "https://files.pythonhosted.org/packages/a9/8b/36db743512d537c012c9635e828a0b73d911ef61d985a5ca93fc450945b7/sphinxcontrib-mermaid-0.8.1.tar.gz"
    sha256 "fa3e5325d4ba395336e6137d113f55026b1a03ccd115dc54113d1d871a580466"
  end

  resource "sphinxcontrib-qthelp" do
    url "https://files.pythonhosted.org/packages/b1/8e/c4846e59f38a5f2b4a0e3b27af38f2fcf904d4bfd82095bf92de0b114ebd/sphinxcontrib-qthelp-1.0.3.tar.gz"
    sha256 "4c33767ee058b70dba89a6fc5c1892c0d57a54be67ddd3e7875a18d14cba5a72"
  end

  resource "sphinxcontrib-serializinghtml" do
    url "https://files.pythonhosted.org/packages/b5/72/835d6fadb9e5d02304cf39b18f93d227cd93abd3c41ebf58e6853eeb1455/sphinxcontrib-serializinghtml-1.1.5.tar.gz"
    sha256 "aa5f6de5dfdf809ef505c4895e51ef5c9eac17d0f287933eb49ec495280b6952"
  end

  resource "sphinxext-opengraph" do
    url "https://files.pythonhosted.org/packages/3a/8e/7c835a3247f350b6b1e38d738d0c132074e0d17d4349634409f920e08b3c/sphinxext-opengraph-0.7.5.tar.gz"
    sha256 "caf061fb3bea8d8f2228f7a1d55cb8f6809f2b5c806bf3600e21ce1a3cf906d1"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/07/d2/d55702e8deba2c80282fea0df53130790d8f398648be589750954c2dcce4/typed_ast-1.5.4.tar.gz"
    sha256 "39e21ceb7388e4bb37f4c679d72707ed46c2fbf2a5609b8b8ebc4b067d977df2"
  end

  resource "types-PyYAML" do
    url "https://files.pythonhosted.org/packages/05/6f/f19081de5ba81864f89e354560a60637822f7d6d54d9a2a907785e9b5cc4/types-PyYAML-6.0.12.9.tar.gz"
    sha256 "c51b1bd6d99ddf0aa2884a7a328810ebf70a4262c292195d3f4f9a0005f9eeb6"
  end

  resource "types-tabulate" do
    url "https://files.pythonhosted.org/packages/51/43/b049d9f82cc6c76f9ffa25064a75cc8cb224fa24954d83382bea42675236/types-tabulate-0.9.0.2.tar.gz"
    sha256 "1dd4322a3a146e9073169c74278b8f14a58eb9905ca9db0d2588df408f27cac9"
  end

  resource "types-xmltodict" do
    url "https://files.pythonhosted.org/packages/0e/3c/e478ade724ea201c6ad6203824fa5395b2302aaf0a2ed2348a247eb4ef6b/types-xmltodict-0.13.0.2.tar.gz"
    sha256 "7a233e65aa828aac611250aa479f9e346a41a8029566ed90dac246c5888304df"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/b7/94/5dd083fc972655f6689587c3af705aabc8b8e781bacdf22d6d2282fe6142/wcmatch-8.4.1.tar.gz"
    sha256 "b1f042a899ea4c458b7321da1b5e3331e3e0ec781583434de1301946ceadb943"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/ab/47/b47d02b741e0aa6f998fc80457d3dfc05cb7732ef480597c2971cbc79260/zipp-3.14.0.tar.gz"
    sha256 "9e5421e176ef5ab4c0ad896624e87a7b2f07aca746c9b2aa305952800cb8eecb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Check mpm is reporting the correct version of itself.
    assert_match "mpm, version #{version}", shell_output("#{bin}/mpm --version")
    # Check mpm is reporting its usage in help screen.
    assert_match "Usage: mpm [OPTIONS] COMMAND [ARGS]...", shell_output("#{bin}/mpm --help")
    # Check mpm is detecting brew and report it as a manager in a table row.
    assert_match(
      /\e\[32mbrew\e\[0m,Homebrew Formulae,\e\[32m✓\e\[0m,\e\[32m✓\e\[0m \S+,\e\[32m✓\e\[0m,\e\[32m✓\e\[0m \S+/,
      shell_output("#{bin}/mpm --output-format csv --all-managers managers"),
    )
    # Check mpm is reporting itself as installed via brew in a table row.
    assert_match "meta-package-manager,,brew,#{version}", shell_output("#{bin}/mpm --output-format csv installed")
  end
end
