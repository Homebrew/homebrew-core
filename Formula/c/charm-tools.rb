class CharmTools < Formula
  include Language::Python::Virtualenv

  desc "Tools for authoring and maintaining juju charms"
  homepage "https://github.com/juju/charm-tools"
  url "https://files.pythonhosted.org/packages/da/8c/26dcc9b99c6fbacd989f5d54b7a3a976cfa5b8ac26f6992d134091add085/charm_tools-3.0.8.tar.gz"
  sha256 "ad1e8aaf8f6aece19f3f7db1d45010b471be998b54a0b2861f24b62912f24b9d"
  license "GPL-3.0-only"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "8b7c31459c1d8582047d79f8189c632deb16d126215605f117186d866bee8b07"
    sha256 cellar: :any,                 arm64_sequoia: "b9bf1be845d1f2954c4a718ee1b854222b8bc45dbe165fbd1a5f40cbb0185130"
    sha256 cellar: :any,                 arm64_sonoma:  "a3826f2a3b51fcd9677d48ee893a240a719a7f48e56083b5f5f21ec90e57c966"
    sha256 cellar: :any,                 sonoma:        "9f20b909364fe5d9d3bdef216eaa78b297e2884fce1354f4b215965df23f0c7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27e82e59687b12734a32041d42c8928d5cd8620c4835a46592ea0c040f62ef28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7366a0245c76bc92f9b038df28c3f88182e4f7d07e0d2f47472416d2ae29981a"
  end

  depends_on "certifi"
  depends_on "charm"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  on_linux do
    depends_on "gmp"
  end

  pypi_packages exclude_packages: ["cheetah3", "certifi", "cryptography"],
                extra_packages:   "ct3"

  # `ruamel-yaml` is manually updated to support Python 3.14
  # PR ref: https://github.com/juju/charm-tools/pull/685

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/5c/f8/9f5e69a63a9243448350b44c87fae74588aa634979e6c0c501f26a4f6df7/blessings-1.7.tar.gz"
    sha256 "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "colander" do
    url "https://files.pythonhosted.org/packages/fa/3c/592bbb25f6199234167d713c220044473e2e57906d7ad7a34e13b7dc1144/colander-1.8.3.tar.gz"
    sha256 "259592a0d6a89cbe63c0c5771f9c0c2522387415af8d715f599583eac659f7d4"
  end

  resource "ct3" do
    url "https://files.pythonhosted.org/packages/a4/61/aa8c457288d06dd160e495b9ede433ba847a29cac41d6dfe56746720acff/ct3-3.4.0.tar.gz"
    sha256 "ddc493b775b02b09737b1fb628a973dbe9aa91d694045a6764a8e3f5296fa1eb"
  end

  resource "dict2colander" do
    url "https://files.pythonhosted.org/packages/aa/7e/5ed2ba3dc2f06457b76d4bc8c93559179472bf87e6982f9a9e5cea30e84e/dict2colander-0.2.tar.gz"
    sha256 "6f668d60896991dcd271465b755f00ffd6f87f81e0d4d054be62a16c086978c7"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "jujubundlelib" do
    url "https://files.pythonhosted.org/packages/57/57/039c6b7e6a01df336f38549eec0836b61166f012528449e37a0ced4e9ddc/jujubundlelib-0.5.7.tar.gz"
    sha256 "7e2b1a679faab13c4d56256e31e0cc616d55841abd32598951735bf395ca47e3"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/55/fe/282f4c205add8e8bb3a1635cbbac59d6def2e0891b145aa553a0e40dd2d0/keyring-23.13.1.tar.gz"
    sha256 "ba2e15a9b35e21908d0aaf4e0a47acc52d6ae33444df0da2b49d41a46ef6d678"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "otherstuf" do
    url "https://files.pythonhosted.org/packages/4f/b5/fe92e1d92610449f001e04dd9bf7dc13b8e99e5ef8859d2da61a99fc8445/otherstuf-1.1.0.tar.gz"
    sha256 "7722980c3b58845645da2acc838f49a1998c8a6bdbdbb1ba30bcde0b085c4f4c"
  end

  resource "parse" do
    url "https://files.pythonhosted.org/packages/4f/78/d9b09ba24bb36ef8b83b71be547e118d46214735b6dfb39e4bfde0e9b9dd/parse-1.20.2.tar.gz"
    sha256 "b41d604d16503c79d81af5165155c0b20f6c8d6c559efa66b4b695c3e5a0a0ce"
  end

  resource "path" do
    url "https://files.pythonhosted.org/packages/96/1c/3950c87aa25437af5f1663cc8627d44ff26f8c5117a5053c9fc3f641027c/path-16.16.0.tar.gz"
    sha256 "a6a6d916c910dc17e0ddc883358756c5a33d1b6dbdf5d6de86554f399053af58"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/32/1a/6baf904503c3e943cae9605c9c88a43b964dea5b59785cf956091b341b08/pathspec-0.10.3.tar.gz"
    sha256 "56200de4077d9d0791465aa9095a01d421861e405b5096955051deefd697d6f6"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/ce/3a/5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95ca/pyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requirements-parser" do
    url "https://files.pythonhosted.org/packages/c2/f9/76106e710015f0f8da37bff8db378ced99ae2553cc4b1cffb0aef87dc4ac/requirements-parser-0.5.0.tar.gz"
    sha256 "3336f3a3ae23e06d3f0f88595e4052396e3adf91688787f637e5d2ca1a904069"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "stuf" do
    url "https://files.pythonhosted.org/packages/76/62/171e06b6d2d3072ea333de19632c61a44f83199e20cbf4924d12827cf66a/stuf-0.9.16.tar.bz2"
    sha256 "e61d64a2180c19111e129d36bfae66a0cb9392e1045827d6495db4ac9cb549b0"
  end

  resource "translationstring" do
    url "https://files.pythonhosted.org/packages/14/39/32325add93da9439775d7fe4b4887eb7986dbc1d5675b0431f4531f560e5/translationstring-1.4.tar.gz"
    sha256 "bf947538d76e69ba12ab17283b10355a9ecfbc078e6123443f43f2107f6376f3"
  end

  resource "types-setuptools" do
    url "https://files.pythonhosted.org/packages/19/bd/1e5f949b7cb740c9f0feaac430e301b8f1c5f11a81e26324299ea671a237/types_setuptools-80.9.0.20250822.tar.gz"
    sha256 "070ea7716968ec67a84c7f7768d9952ff24d28b65b6594797a464f1b3066f965"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "vergit" do
    url "https://files.pythonhosted.org/packages/d8/dc/2ef077a97a05633bbe7a46b9cb4b87fbf994a9aaa52b44a8f1086d20951f/vergit-1.0.2.tar.gz"
    sha256 "ea82a4d6057d4891a4b16e0881bd756ceea2b66253edc05dd619450f88a5ff31"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a4/d5/b0ccd381d55c8f45d46f77df6ae59fbc23d19e901e2d523395598e5f4c93/virtualenv-20.35.3.tar.gz"
    sha256 "4f1a845d131133bdff10590489610c98c168ff99dc75d6c96853801f7f67af44"
  end

  def install
    # Unpin ruamel.yaml to support Python 3.14
    # PR ref for 3.13: https://github.com/juju/charm-tools/pull/685
    inreplace "setup.py", "ruamel.yaml<0.18", "ruamel.yaml<0.19"

    venv = virtualenv_install_with_resources without: "ct3"
    resource("ct3").stage do
      # Package was renamed due to PyPI 2FA requirement and charm-tools use of
      # `pkg_resources` raises an exception on missing requirement
      # https://github.com/CheetahTemplate3/cheetah3/commit/673259b2d139b4ea970b1c2da12607b7ac39cbec
      inreplace "SetupConfig.py", "name = 'CT3'", "name = 'cheetah3'"
      venv.pip_install Pathname.pwd
    end
  end

  test do
    system bin/"charm-create", "brewtest"
    assert_path_exists testpath/"brewtest/metadata.yaml"

    assert_match version.to_s, shell_output("#{bin}/charm-version")
  end
end
