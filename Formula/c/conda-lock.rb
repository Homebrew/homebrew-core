class CondaLock < Formula
  include Language::Python::Virtualenv

  desc "Lightweight lockfile for conda environments"
  homepage "https://conda.github.io/conda-lock/"
  url "https://files.pythonhosted.org/packages/06/44/52deb5012f8ef85c224cb3b1638c09c3b3d70b2f9e101e893bb61b9ee9ba/conda_lock-4.0.2.tar.gz"
  sha256 "c4ebc4404ea760b1dd0035d6403fa27e291050269a5fd1b629b89fcbc75ef32a"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5b18be94550286946253d5edae48cd3ab367d0920466cf3657a02ab3e8f1671f"
    sha256 cellar: :any, arm64_sequoia: "ae0137c26b694430d2f0da7a0e58e71732f4b105f7365ec4379ea25d0295fe3b"
    sha256 cellar: :any, arm64_sonoma:  "59d5b1d5c6da5da39c206a4925bd62dcd67c180fb005a9fda81e57f0b82e2a9a"
    sha256 cellar: :any, sonoma:        "628fd41305072d7814a5450811c24a4be104a4548b9f1752e054a40d791864f9"
    sha256 cellar: :any, arm64_linux:   "06c28a3048e9445b31048ac84e36ff127095e549e82666bceead0a6051d69770"
    sha256 cellar: :any, x86_64_linux:  "7e73ec6eadbf69d076e276f46504cae48f6cd2f9db3ae69dcf72919a1a2c7eae"
  end

  depends_on "rust" => :build # for cachecontrol, uv-backend
  depends_on "micromamba" => :test
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "zstd"

  on_linux do
    depends_on "cryptography" # for secretstorage
  end

  pypi_packages exclude_packages: ["certifi", "cryptography", "pydantic"],
                extra_packages:   ["jeepney", "secretstorage", "xattr"]

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/47/99/12bace94ae2ba961bdc46d49277ff15d38dba074bc3987b0c0b4355a37a7/boltons-26.1.0.tar.gz"
    sha256 "5764468aba493b15995ed17f46a16789023f123ca2a62d491a9ce825c1cbe26c"
  end

  resource "build" do
    url "https://files.pythonhosted.org/packages/78/e0/df5e171f685f82f37b12e1f208064e24244911079d7b767447d1af7e0d70/build-1.5.0.tar.gz"
    sha256 "302c22c3ba2a0fd5f3911918651341ebb3896176cbdec15bd421f80b1afc7647"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/2d/f6/c972b32d80760fb79d6b9eeb0b3010a46b89c0b23cf6329417ff7886cd22/cachecontrol-0.14.4.tar.gz"
    sha256 "e6220afafa4c22a47dd0badb319f84475d79108100d04e26e8542ef7d3ab05a1"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "conda-package-streaming" do
    url "https://files.pythonhosted.org/packages/d2/71/3c322ae0db04ce7fafff8c0b304d71cc15258cd91a6231bb0f0e3d8fa6c2/conda_package_streaming-0.13.0.tar.gz"
    sha256 "b2599426dee4a81bfe6aa40d5fb0a22ae5ff842a0a7f9df59f013bfbcd369f72"
  end

  resource "crashtest" do
    url "https://files.pythonhosted.org/packages/6e/5d/d79f51058e75948d6c9e7a3d679080a47be61c84d3cc8f71ee31255eb22b/crashtest-0.4.1.tar.gz"
    sha256 "80d7b1f316ebfbd429f648076d6275c877ba30ba48979de4191714a75266f0ce"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/3e/7c/cb4a5fb0d3d0f6585894759730ae9052e8dd9d2e5172bff544d369b24243/dulwich-0.24.10.tar.gz"
    sha256 "30e028979b6fa7220c913da9c786026611c10746c06496149742602b36a11f6b"
  end

  resource "ensureconda" do
    url "https://files.pythonhosted.org/packages/d4/80/49c5df6f90d1bad1d2b071c2f4937edb0cc9bd060ffef274bb16878a7a4f/ensureconda-1.6.0.tar.gz"
    sha256 "52b3279cd48002cd0ed5f42a00dd1e4a9086a99d1fa68375e8920fde95f77738"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/20/b5/23b216d9d985a956623b6bd12d4086b60f0059b27799f23016af04a74ea1/fastjsonschema-2.21.2.tar.gz"
    sha256 "b1eb43748041c880796cd077f1a07c3d94e93ae84bba5ed36800a33554ae05de"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/99/2c/c603f8aedff281295f7afce455d5c05f33459c7bf684abb46228f844a1f0/filelock-3.31.2.tar.gz"
    sha256 "e6d35965c709527915a184837a8421826d18bc3f9d7e9a5a0c8114a782475d66"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/17/24/0e0c12cb6f7cb864779a9d2fefee9ca91838f6db402c8780c9d28a8d7ebe/gitpython-3.1.53.tar.gz"
    sha256 "06ae8d9623b0ed0d67b8adeac5c7008d0a5a404b087a9e0d0c7163bdd3a6b497"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/06/fe/b9f481cf0cc867958a21338baa900357b7b7d86cac9b025948049d77923c/installer-1.0.1.tar.gz"
    sha256 "052c7fc3721d54c696e2dea019be67539d7b144e924f559f54beb3121831c364"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/31/f9/c0a1c127f9049db9155afc316952ea571720dd01833ff5e4d7e8e6352dbb/msgpack-1.2.1.tar.gz"
    sha256 "04c721c2c7448767e9e3f2520a475663d8ee0f09c31890f6d2bd70fd636a9647"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/24/03/e26bf3d6453b7fda5bd2b84029a426553bb373d6277ef6b5ac8863421f87/pkginfo-1.12.1.2.tar.gz"
    sha256 "5cd957824ac36f140260964eba3c6be6442a8359b8c48f4adf90210f33a04b7b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/52/cd/4f25b2f95b23f5d2c9c1fe43e49841bff5800562149b2666afc09309aa8f/platformdirs-4.10.1.tar.gz"
    sha256 "ceab4084426fe6319ce18e86deada8ab1b7487c7aee7040c55e277c9ae793695"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/c2/e3/7ca82ee24c82d344584abd5b8637b3bd056f2900226e8d82fc22f1184b92/trove_classifiers-2026.6.1.19.tar.gz"
    sha256 "c5132b4b61a829d11cfbd2d72e97f20a45ed6edb95e45c5efdeb5e00836b2745"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/08/28/3b1b939f7d7d1b370c86919fcbc7e44549aa5bd94254b5ca8f8cb10d8aef/virtualenv-20.39.1.tar.gz"
    sha256 "c551ea1072d7717a273dd9a4a0adad8f45571af134b0f63a12430e85f6ac1c08"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/08/d5/25f7b19af3a2cb4000cac4f9e5525a40bec79f4f5d0ac9b517c0544586a0/xattr-1.3.0.tar.gz"
    sha256 "30439fabd7de0787b27e9a6e1d569c5959854cb322f64ce7380fedbfa5035036"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    without = ["zstandard"]
    without += OS.mac? ? ["jeepney", "secretstorage"] : ["xattr"]
    venv = virtualenv_install_with_resources(without:)

    resource("zstandard").stage do
      system_zstd = "--config-settings=--build-option=--system-zstd"
      system venv.root/"bin/python", "-m", "pip", "install", system_zstd, *std_pip_args(prefix: false), "."
    end

    generate_completions_from_executable(bin/"conda-lock", shell_parameter_format: :click)
  end

  test do
    assert_equal "#{name}, version #{version}", shell_output("#{bin}/conda-lock --version").strip

    (testpath/"environment.yml").write <<~YAML
      name: testenv
      channels:
        - conda-forge
      dependencies:
        - python=3.14
    YAML
    system bin/"conda-lock", "-p", "osx-64", "-p", "osx-arm64",
                             "--conda", formula_opt_bin("micromamba")/"mamba"
    assert_path_exists testpath/"conda-lock.yml"
  end
end
