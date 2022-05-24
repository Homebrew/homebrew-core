class Molecule < Formula
  include Language::Python::Virtualenv

  desc "Automated testing for Ansible roles"
  homepage "https://molecule.readthedocs.io"
  url "https://files.pythonhosted.org/packages/3e/34/df573d20078d2056c90b0f7ddf8f43cd06da830a5e87881c6f415877a1a1/molecule-3.6.1.tar.gz"
  sha256 "3b7d5ba2978c15a034df8c7aa59dec5436f7d3260d1f9db2c78ae14ae3a9deeb"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b09c3cb8a7906cae1a380e719d9d8e6ad1ab99a5f3bec53f6d1e9c7e893b9726"
    sha256 cellar: :any,                 arm64_big_sur:  "3d4af43068241462090100f7898c2ea108faa086d96cb30d328f7459ce5fad7b"
    sha256 cellar: :any,                 monterey:       "47998c59b4a26c519cf8fcf59e04ea9b7a985a86c2e32b188a60962425d0a205"
    sha256 cellar: :any,                 big_sur:        "a23f91fe109579e55e08ed68c15362dce29fbddaf4d991253c0fdab48dd60953"
    sha256 cellar: :any,                 catalina:       "07973715313291279f3cef2725d240f18cd92c79cc2317fff6f248fe3d93388b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0158ed4b570ce19fcbe68a5b1bd5f0606098b6749536c0e0d112daf2743cc8a5"
  end

  depends_on "rust" => :build
  depends_on "ansible"
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gmp"
  end

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/33/79/f74e03dbb2d97f9370b8b6ddaa38c3e2fa4f842d7c85d68f46ea341f55fb/ansible-compat-2.0.3.tar.gz"
    sha256 "a1157e4059de41879f3f65d5ed62bf343fe5bd45286101e2d2971ffe57e3a8a5"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/48/28/30a5748af715b0ab9c2b81cf08bd9e261e47a6261e247553afb7f6421b24/arrow-1.2.2.tar.gz"
    sha256 "05caf1fd3d9a11a1135b2b6f09887421153b94558e5ef4d090b567b47173ac2b"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/e8/36/edc85ab295ceff724506252b774155eff8a238f13730c8b13badd33ef866/bcrypt-3.2.2.tar.gz"
    sha256 "433c410c2177057705da2a9f2cd01dd157493b2a7ac14c8593a16b3dab6b6bfb"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "Cerberus" do
    url "https://files.pythonhosted.org/packages/90/a7/71c6ed2d46a81065e68c007ac63378b96fa54c7bb614d653c68232f9c50c/Cerberus-1.3.2.tar.gz"
    sha256 "302e6694f206dd85cb63f13fd5025b31ab6d38c99c50c6d769f8fa0b0f299589"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-help-colors" do
    url "https://files.pythonhosted.org/packages/6c/c1/abc07420cfdc046c1005e16bc8090bc1f226d631b2bd172e5a8f5524c127/click-help-colors-0.9.1.tar.gz"
    sha256 "78cbcf30cfa81c5fc2a52f49220121e1a8190cd19197d9245997605d3405824d"
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
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/b5/7e/ddfbd640ac9a82e60718558a3de7d5988a7d4648385cf00318f60a8b073a/distro-1.7.0.tar.gz"
    sha256 "151aeccf60c216402932b52e40ee477a939f8d58898927378a02abbe852c1c39"
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

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jinja2-time" do
    url "https://files.pythonhosted.org/packages/de/7c/ee2f2014a2a0616ad3328e58e7dac879251babdb4cb796d770b5d32c469f/jinja2-time-0.2.0.tar.gz"
    sha256 "d14eaa4d315e7688daa4969f616f226614350c48730bfa1692d2caebd8c90d40"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "molecule-vagrant" do
    url "https://files.pythonhosted.org/packages/ae/6c/419f7aebe62d9cf523245c59a02dd79290f38408ac5a80e80fcd389863f8/molecule-vagrant-1.0.0.tar.gz"
    sha256 "fc1e988147226ada8288475b768c52a37366c8b50d30b91635cacfc64e1468c3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/a1/9b/737c2306468a9fce2d630f12c2f29a2674d7bbe406819334c0883e929812/paramiko-2.10.4.tar.gz"
    sha256 "3d2e650b6812ce6d160abff701d6ef4434ec97934b13e95cf1ad3da70ffb5c58"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "poyo" do
    url "https://files.pythonhosted.org/packages/7d/56/01b496f36bbd496aed9351dd1b06cf57fd2f5028480a87adbcf7a4ff1f65/poyo-0.5.0.tar.gz"
    sha256 "e26956aa780c45f011ca9886f044590e2d8fd8b61db7b1c1cf4e0869f48ed4dd"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/5d/45/915967d7bcc28fd12f36f554e1a64aeca36214f2be9caf87158168b5a575/python-slugify-6.1.2.tar.gz"
    sha256 "272d106cb31ab99b3496ba085e3fea0e9e76dcde967b5e9992500d1f785ce4e1"
  end

  resource "python-vagrant" do
    url "https://files.pythonhosted.org/packages/2b/3f/2e42a44c9705d72d9925fe8daf00f31bcf82e8b84ec5a752a8a1357c3ef8/python-vagrant-1.0.0.tar.gz"
    sha256 "a8fe93ccf2ff37ecc95ec2f49ea74a91a6ce73a4db4a16a98dd26d397cfd09e5"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/72/4d/1f48abaa1e91474af1be8622ec2a8bd3768b306def47b064aa15aa943f95/rich-12.4.1.tar.gz"
    sha256 "d239001c0fb7de985e21ec9a4bb542b5150350330bbc1849f835b9cbc8923b91"
  end

  resource "selinux" do
    url "https://files.pythonhosted.org/packages/1a/f1/5755b134895bb9b29d6937cae52d0f58140bb97df0f72c33231345294e80/selinux-0.2.1.tar.gz"
    sha256 "d435f514e834e3fdc0941f6a29d086b80b2ea51b28112aee6254bd104ee42a74"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/48/20/a38a078b58532bd44c4c189c85cc650268d1894a1dcc7080b6e7e9cfe7bb/subprocess-tee-0.3.5.tar.gz"
    sha256 "ff5cced589a4b8ac973276ca1ba21bb6e3de600cde11a69947ff51f696efd577"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/7c/de/9f5354b4b37df453b7d664f587124c70a75c81805095d491d39f5b591818/websocket-client-1.3.2.tar.gz"
    sha256 "50b21db0058f7a953d67cc0445be4b948d7fc196ecbeb8083d68d94628e4abf6"
  end

  def install
    virtualenv_install_with_resources
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
