class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/62/4d/f60f3ba1ffd218496e1f4c75f5cbf4dd2aab4d12a24cca38d000316d8313/dvc-1.11.4.tar.gz"
  sha256 "b72c87317a0a98bfdb6162d7ee372f2736baf8340b0b03da8ed076bf3b54927f"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "cfcda7b7e2450692c41ee62fd3a4072b28a0a2c25f33f505d4308620b3673492" => :big_sur
    sha256 "b87e0e615936f146e050a2dabb837e03c9bae653172d38ae9d5bfe80142615ed" => :catalina
    sha256 "080f6286e0dbba3675dd1c02ae9b238c76ea551d497d4984932f7e1d78259365" => :mojave
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
    url "https://files.pythonhosted.org/packages/8c/cf/c152396a909f206fae8efee77e22ced3dc4f4599bb51fc445d8f4a7e6b4d/atpublic-2.1.1.tar.gz"
    sha256 "fa1d48bcb85bbed90f6ffee6936578f65ff0e93aa607397bd88eaeb408bd96d8"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
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
    url "https://files.pythonhosted.org/packages/c7/6d/b5ee7c6a5d202b41efa356a56efd5b1990eab518d9e583e621da0b1cf509/dulwich-0.20.14.tar.gz"
    sha256 "21d6ee82708f7c67ce3fdcaf1f1407e524f7f4f7411a410a972faa2176baec0d"
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
    url "https://files.pythonhosted.org/packages/85/3d/ee9aa9c77a3c0e9074461d2d8da86c3564ed96abd28fa099dc3e05338a72/GitPython-3.1.11.tar.gz"
    sha256 "befa4d101f91bad1b632df4308ec64555db684c360bd7d2130b4807d49ce86b8"
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
    url "https://files.pythonhosted.org/packages/82/c6/96061721fffa414caf73ef4257f0b8752a1e663a05d683963b14837dc7f9/mailchecker-4.0.1.tar.gz"
    sha256 "cbdc4fb028c9d4f3ecad8b6448f69e695a810c83c8dcdc2fd0c28c65bcd74ba0"
  end

  resource "nanotime" do
    url "https://files.pythonhosted.org/packages/d5/54/6d5924f59cf671326e7809f4b3f70fa8df535d67e952ad0b6fea02f52faf/nanotime-0.5.2.tar.gz"
    sha256 "c7cc231fc5f6db401b448d7ab51c96d0a4733f4b69fabe569a576f89ffdf966b"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/bf/63/7b579dd3b1c49ce6b7fd8f6f864038f255201410905dd183cf7f4a3845cf/networkx-2.4.tar.gz"
    sha256 "f8f4ff0b6f96e4f9b16af6b84622597b5334bf9cae8cf9b2e42e7985d5c95c64"
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
    url "https://files.pythonhosted.org/packages/ba/68/d62976cf138569339bbfaaa8710112e595673d669efb5eee47559f7c5aa9/phonenumbers-8.12.14.tar.gz"
    sha256 "58817072cf2b80fcc8710e7a2c395cd32fce2b70a259e36ff81916862f578d61"
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
    url "https://files.pythonhosted.org/packages/29/60/8ff9dcb5eac7f4da327ba9ecb74e1ad783b2d32423c06ef599e48c79b1e1/Pygments-2.7.3.tar.gz"
    sha256 "ccf3acacf3782cbed4a989426012f1c535c9a90d3a7fc3f16d231b9372d2b716"
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
    url "https://files.pythonhosted.org/packages/6c/22/0382506ff4291a8faca58b91eb994dcd697d533cd0f449db22471a697be1/python-benedict-0.22.2.tar.gz"
    sha256 "20fa5a2e0fe920f65567a77e8173e3edd8f532a7c5b5cd320855a6077de67ee8"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/9f/42/e336f96a8b6007428df772d0d159b8eee9b2f1811593a4931150660402c0/python-slugify-4.0.1.tar.gz"
    sha256 "69a517766e00c1268e5bbfc0d010a0a8508de0b18d30ad5a1ff357f8ae724270"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9f/14/4a6542a078773957aa83101336375c9597e6fe5889d20abda9c38f9f3ff2/requests-2.25.0.tar.gz"
    sha256 "7f1a0b932f4a60a1a65caa4263921bb7d9ee911957e0ae4a23a6dd08185ad5f8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ca/c6/ec17c91601b9ffd1a21cea6cf4939864a3128f8fc25f3fb7bf858cec6446/rich-9.4.0.tar.gz"
    sha256 "bde23a1761373fed2802502ff98292c5d735a5389ed96f4fe1be5fb4c2cde8ea"
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
    url "https://files.pythonhosted.org/packages/ef/14/6b75b49169e84019bdacecddb6137d01e005a5b3014c577e96bdd5131bca/shtab-1.3.3.tar.gz"
    sha256 "1f7f263631acdf0a9e685bbf7126a0fa711c2d663db12441670b1cea3fa431d4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/75/fb/2f594e5364f9c986b2c89eb662fc6067292cb3df2b88ae31c939b9138bb9/smmap-3.0.4.tar.gz"
    sha256 "9c98bbd1f9786d22f14b3d4126894d56befb835ec90cef151af566c7e19b5d24"
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
    url "https://files.pythonhosted.org/packages/80/e9/a51c724ce67ff24a18861af5b0c6f9468e4b4ecdbd53fd43a9288b856372/tqdm-4.54.1.tar.gz"
    sha256 "38b658a3e4ecf9b4f6f8ff75ca16221ae3378b2e175d846b6b33ea3a20852cf5"
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
