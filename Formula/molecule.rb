class Molecule < Formula
  include Language::Python::Virtualenv

  desc "Automated testing for Ansible roles"
  homepage "https://molecule.readthedocs.io"
  url "https://files.pythonhosted.org/packages/e4/55/66648b26f1ea76127ff976dae906a74eccb6807ac27ff7645c046b78e195/molecule-5.0.1.tar.gz"
  sha256 "15a4c89e82ec1319bb1b36430061a103b91f1eb6d000b54330a161f4c8ee62d7"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "5535be3d3ac87c1acb4eb8c1d097d497dad22a545b1632aa996548a73ad75e50"
    sha256 cellar: :any,                 arm64_monterey: "3cf6f9dfa62831454b8793cd9e5d7758775280a9eb2acb1dd5938fabd8e3ca73"
    sha256 cellar: :any,                 arm64_big_sur:  "9ae75d1c2fc95928a3a66ce4758a39b5be24b43aac3b97dffe0511ed7a9e4258"
    sha256 cellar: :any,                 ventura:        "1611bf1cc11f70779734741cae1413c0e96bd72cada4309c7c8277bd2759f50d"
    sha256 cellar: :any,                 monterey:       "819d27b1a6e9beabb15ec964c8965d2400c4102f2c8cfa4e402d898defca4c08"
    sha256 cellar: :any,                 big_sur:        "65192eb93daeae6f8a46c72ad59afbeff3547d9ff588df9add15234fa96a63c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e56a3388ee3141c03b42150bfd4b192d3761a8d78da227a919a99d3b4337dcda"
  end

  depends_on "rust" => :build
  depends_on "ansible"
  depends_on "cffi"
  depends_on "cookiecutter"
  depends_on "openssl@1.1"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gmp"
  end

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/97/0e/e676c7abe5f07615df177725180bee7302aa01fc04a083306f1faa5ec97b/ansible-compat-3.0.2.tar.gz"
    sha256 "a10ea191f9efe08590ff64cb46a31af1f8142c08618db1a4bc827ed257c68230"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/12/10/9f3bed762e4f867c7fd32f125cf4d11a9dfb8e60e6565e14a1b4f2bf3396/ansible-core-2.15.0.tar.gz"
    sha256 "cf690fd4ebb40590e00c5acdc0624758ca4c58d1e4b2b02ec026a034070ebf4d"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "click-help-colors" do
    url "https://files.pythonhosted.org/packages/6c/c1/abc07420cfdc046c1005e16bc8090bc1f226d631b2bd172e5a8f5524c127/click-help-colors-0.9.1.tar.gz"
    sha256 "78cbcf30cfa81c5fc2a52f49220121e1a8190cd19197d9245997605d3405824d"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
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
    url "https://files.pythonhosted.org/packages/bb/77/cb9b3d6f2e2e5f8104e907ea4c4d575267238f52c51cf9f864b865a99710/enrich-1.2.7.tar.gz"
    sha256 "0a2ab0d2931dff8947012602d1234d2a3ee002d9a355b5d70be6bf5466008893"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "molecule-vagrant" do
    url "https://files.pythonhosted.org/packages/c9/ad/0ed60a69cd6887622ff03d67beacbc54183f9d6fa45978c37dc35a315b30/molecule-vagrant-2.0.0.tar.gz"
    sha256 "bb27f4ec482d0f68231f31136bfba328fc8ef7d81341874284bdd71295e278d5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-vagrant" do
    url "https://files.pythonhosted.org/packages/2b/3f/2e42a44c9705d72d9925fe8daf00f31bcf82e8b84ec5a752a8a1357c3ef8/python-vagrant-1.0.0.tar.gz"
    sha256 "a8fe93ccf2ff37ecc95ec2f49ea74a91a6ce73a4db4a16a98dd26d397cfd09e5"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ce/10/f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6/resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/02/97/0046b5e3c6a5057b5817e5e6c51a776d410b953e6a9c67ae249dafdd2999/rich-13.4.1.tar.gz"
    sha256 "76f6b65ea7e5c5d924ba80e322231d7cb5b5981aa60bfc1e694f1bc097fe6fe1"
  end

  resource "selinux" do
    url "https://files.pythonhosted.org/packages/25/07/51acd62e1e15e1172d46f7e32faf138725b147f8c08dbf2d512159d7a310/selinux-0.3.0.tar.gz"
    sha256 "2a88b337ac46ad0f06f557b2806c3df62421972f766673dd8bf26732fb75a9ea"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/f6/a0/acafd85c7c0aead293a16a70a49aba20ba2af9478771370b2897eae6059c/subprocess-tee-0.4.1.tar.gz"
    sha256 "b3c124993f8b88d1eb1c2fde0bc2069787eac720ba88771cba17e8c93324825d"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/3f/f2/2624e12ef854ee667d92ac5dc7815932095e0852e5ff2b2bf57feda8a11b/websocket-client-1.5.2.tar.gz"
    sha256 "c7d67c13b928645f259d9b847ab5b57fd2d127213ca41ebd880de1f553b7c23b"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.11")
    %w[cookiecutter].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TMP"] = testpath/"tmp"
    # Test the Vagrant driver
    system bin/"molecule", "init", "role", "acme.foo_vagrant", "--driver-name",
                           "vagrant", "--verifier-name", "testinfra"
    assert_predicate testpath/"foo_vagrant/molecule/default/molecule.yml", :exist?,
                     "Failed to create 'foo_vagrant/molecule/default/molecule.yml' file!"
    assert_predicate testpath/"foo_vagrant/molecule/default/tests/test_default.py", :exist?,
                     "Failed to create 'foo_vagrant/molecule/default/tests/test_default.py' file!"
    cd "foo_vagrant" do
      system bin/"molecule", "list"
    end
  end
end
