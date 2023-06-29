class Molecule < Formula
  include Language::Python::Virtualenv

  desc "Automated testing for Ansible roles"
  homepage "https://molecule.readthedocs.io"
  url "https://files.pythonhosted.org/packages/e7/69/c2d5028b1cab582dd2df69d8603a6300c2f2ffeaaa14abcaed56f152a1a4/molecule-5.1.0.tar.gz"
  sha256 "fa7af89fdf9317539c3eca99cb1e5e7522d7a57e0b67f5b698e44276f98d9d82"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dfc59c83f4b143dfbbd0e7979c3ab7806529e82aac87d28d0de032050ca4f574"
    sha256 cellar: :any,                 arm64_monterey: "5a91399d33e1601bd72a3b248a0401c7b23dc016f75771028b000b0edc2c343c"
    sha256 cellar: :any,                 arm64_big_sur:  "b1d26461cf2ef03538f356a7c4b452efcee54d0058766a9e0e47428385360c51"
    sha256 cellar: :any,                 ventura:        "d8c597dad5a6fa3233a646716d69fae30195fa933d87a38cef8b5eb19129faf4"
    sha256 cellar: :any,                 monterey:       "08f45bbd341072c818acc25e4716757e4dede3cbe1919a83fc57b514eea070a9"
    sha256 cellar: :any,                 big_sur:        "e2a16b1486534a99270639977ecbb7b25f5d59d8eef033b59c6e30cae647882a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb57285ef860255e0a21d4086733f49b4ed967bf6dc0c941656c89e4b83426b"
  end

  depends_on "rust" => :build
  depends_on "ansible"
  depends_on "cffi"
  depends_on "cookiecutter"
  depends_on "openssl@3"
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
    url "https://files.pythonhosted.org/packages/18/22/6e223b82ba3577788348168b366ab1418c08ce1cd80c3f999bac4196d614/ansible-compat-4.1.2.tar.gz"
    sha256 "696162dbc1223c0b474136a61662b3fe44115d490de8da606b149cee572b01ed"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/1e/34/ba701d49f78d8aead7c20339bbc1eccc682894f08dc48f5c391792282c65/ansible-core-2.15.1.tar.gz"
    sha256 "ed28eb4943e480004edc9ba1e9bee979a0650cb2f9372ce4a2bd572838c60d2b"
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
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
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
    url "https://files.pythonhosted.org/packages/8a/42/8f2833655a29c4e9cb52ee8a2be04ceac61bcff4a680fb338cbd3d1e322d/pluggy-1.2.0.tar.gz"
    sha256 "d12f0c4b579b15f5e054301bb226ee85eeeba08ffec228092f8defbaa3a4c4b3"
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
    url "https://files.pythonhosted.org/packages/e3/12/67d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538fee/rich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
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
    url "https://files.pythonhosted.org/packages/b1/34/3a5cae1e07d9566ad073fa6d169bf22c03a3ba7b31b3c3422ec88d039108/websocket-client-1.6.1.tar.gz"
    sha256 "c951af98631d24f8df89ab1019fc365f2227c0892f12fd150e935607c79dd0dd"
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
