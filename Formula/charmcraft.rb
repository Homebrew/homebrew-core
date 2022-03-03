class Charmcraft < Formula
  include Language::Python::Virtualenv

  desc "Tool to build charms and publish them on Charmhub"
  homepage "https://charmhub.io"
  url "https://files.pythonhosted.org/packages/52/50/30c04cb53128c841ee8e0365368cdac9d00cc5cb7196f0202c3bbe9962ea/charmcraft-1.4.0.tar.gz"
  sha256 "5936a211c191e744b3d41769d77d0aff8ac0564f4cec8f49410d6e76b99b4430"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff67632880ba97a2d858b2c18271dac257279dd07953dcbcae78245506dc74f4"
    sha256 cellar: :any,                 arm64_big_sur:  "351a540a8d47b02a92ad872af020dbdcda366eb81922e37a4171cce6c9f026c3"
    sha256 cellar: :any,                 monterey:       "f16d4882008b010e460e8a0d8e58b7510a24b20982331000fbc5483d97ffb78a"
    sha256 cellar: :any,                 big_sur:        "90d9f09d60bf2091141f1b598b23d5f12098895116edc0ff9797ee0e6908c8c9"
    sha256 cellar: :any,                 catalina:       "99b9ea0379fa15a791474a847f9869f1f4fd460b57e8250178ddef1f511a0a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47cdf65ffda26a107a637caebf62fabb88485be3a9160a0b6deaf9f6ed6c8cd6"
  end

  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/48/44/76b179e0d1afe6e6a91fd5661c284f60238987f3b42b676d141d01cd5b97/charset-normalizer-2.0.10.tar.gz"
    sha256 "876d180e9d7432c5d1dfd4c5d26b72f099d503e8fcc0feb7532c9289be60fcbd"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/ab/33/a17dc6e71292b6bf568738e10d4563a3c0c4f2a77d3fc3e3f282fd2cc26e/craft-parts-1.1.1.tar.gz"
    sha256 "33b9e3895aff512e76e0b7c963b0f386c90a10a58eeffbdb189ffedbdae910c7"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/53/1e/8fd1513c39312225f5a5bb13552965ebd4d090df255c4279aef64fc32b2c/craft-providers-1.0.3.tar.gz"
    sha256 "f9bcdd58515a28f0f4049cd200ef9ac3e9f311609403be356fe3c40b128a5d36"
  end

  resource "craft-store" do
    url "https://files.pythonhosted.org/packages/f8/50/e7f932a9d4084a5ffc735306e4ab6d140206358b8ea508aba07a48d27f26/craft-store-1.2.0.tar.gz"
    sha256 "5c45c817d1895cb158b076de57d41ae5c2d07db5aca9fc50f30119dc0dbbaa47"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ea/d8/2afd2890fe451a3c109d2bdb6bc4ded55ec43059e524344d5e0004e36412/cryptography-3.4.tar.gz"
    sha256 "9f7aa11ea95723359f914be3217d8b378bc3897f65a1ec1ab4e0118c336f51fc"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/8a/b6/e7d99d1cc225a069f3f7a906a213cb1a0148dac27119290c41dc257ffe53/humanize-3.13.1.tar.gz"
    sha256 "12f113f2e369dac7f35d3823f49262934f4a22a53a6d3d4c86b736f50db88c7b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/50/05/fef7fbb7e781e0632ebba4e6e37bcc88b9615e76338850dc31435091ddc0/importlib_metadata-4.10.0.tar.gz"
    sha256 "92a8b58ce734b2a4494878e0ecf7d79ccd7a128b5fc6014c401e0b61f006f0f6"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/26/67/36cfd516f7b3560bbf7183d7a0f82bb9514d2a5f4e1d682a8a1d55d8031d/jsonschema-4.4.0.tar.gz"
    sha256 "636694eb41b3535ed608fe04129f26542b59ed99808b4f688aa32dcf55317a83"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/22/2b/e840597838cc63f96926bd7daca67936031635cfe6c81ee12dc652bd2dce/keyring-23.5.0.tar.gz"
    sha256 "9012508e141a80bd1c0b6778d5c610dd9f8c464d75ac6774248500503f972fb9"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/52/40/2a8bb2f507ce1a6c5b896c1b98044d74d34b07a6dd771526b4fe84e3181f/macaroonbakery-1.3.1.tar.gz"
    sha256 "23f38415341a1d04a155b4dac6730d3ad5f39b86ce07b1bb134bdda52b48b053"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/52/86/7f70ed8b5957b094a432cc839ea99cffac62a41861d4d2075d742a45953b/overrides-6.1.0.tar.gz"
    sha256 "5ba636b73bf72d3d80550f4a5dfe3c7d04ec6e8fd246c4074bfc7ad82bd0ea3d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/d5/bf6c307f58b4c486f6517341d2f2673cd889b7d3a83cae78a9081233c679/protobuf-3.19.3.tar.gz"
    sha256 "d975a6314fbf5c524d4981e24294739216b5fb81ef3c14b86fb4b045d6690907"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b9/d2/12a808613937a6b98cd50d6467352f01322dc0d8ca9fb5b94441625d6684/pydantic-1.8.2.tar.gz"
    sha256 "26464e57ccaafe72b7ad156fdaa4e9b9ef051f69e175dbbb463283000c05ab7b"
  end

  resource "pydantic-yaml" do
    url "https://files.pythonhosted.org/packages/47/ff/187bcb7afe2cb53c34be7ee71dca8a53bf9e83c0b2b0ad2b3781b18f5bd4/pydantic_yaml-0.4.3.tar.gz"
    sha256 "97772436c334416d85bbaeba4fc6936a46febd2523ef1e53c3957ddf27cf1b30"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/6f/2e/2251b5ae2f003d865beef79c8fcd517e907ed6a69f58c32403cec3eba9b2/pyxdg-0.27.tar.gz"
    sha256 "80bd93aae5ed82435f20462ea0208fb198d8eec262e831ee06ce9ddb6b91c5a5"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/c3/ea/0fb87f844d8a35ff0dcc8b941e1a9ffc9eb46588ac9e4267b9d9804354eb/requests-unixsocket-0.3.0.tar.gz"
    sha256 "28304283ea9357d45fff58ad5b11e47708cfbf5806817aa59b2a363228ee971e"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/d4/52/3be868c7ed1f408cb822bc92ce17ffe4e97d11c42caafce0589f05844dd0/semantic_version-2.8.5.tar.gz"
    sha256 "d2cb2de0558762934679b9a104e82eca7af448c9f4974d1f3eeccff651df8a54"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/67/08/e1aa2c582c62ac76e4d60f8e454bd3bba933781a06a88b4e38797445822a/setuptools-rust-1.1.2.tar.gz"
    sha256 "a0adb9b503c0ffc4e8fe80b7c617898cefa78049983aaaea7f747e153a3e65d1"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/54/a4/7f11eb8d96826cfe17c4c68b907f8005d97ad1ef23dea67aa3d39287f6d7/snap-helpers-0.2.0.tar.gz"
    sha256 "e72c810af32a0126bfcb7d5c39dda5ca2037889ca2fe2ee5aa543a25b9ca670b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0d/4a/60ba3706797b878016f16edc5fbaf1e222109e38d0fa4d7d9312cb53f8dd/typing_extensions-4.0.1.tar.gz"
    sha256 "4ca091dea149f945ec56afb48dae714f21e8692ef22a395223bcd328961b6a0e"
  end

  resource "typing-utils" do
    url "https://files.pythonhosted.org/packages/c0/9f/ddc5ed9182f49d6ca5d87a7629dea81ca076db54f30f78d057a081f5ec50/typing_utils-0.1.0.tar.gz"
    sha256 "8ff6b6705414b82575ad5ae0925ac414a9650fb8c5718289b1327dec61252f65"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/94/64/3115548d41cb001378099cb4fc6a6889c64ef43ac1b0e68c9e80b55884fa/zipp-3.7.0.tar.gz"
    sha256 "9f50f446828eb9d45b267433fd3e9da8d801f614129124863f9c51ebceafb87d"
  end

  # Fixes unspecified dependency: https://github.com/canonical/charmcraft/issues/617
  # Remove this and `extra_packages` from `pypi_formula_mappings.json` when fixed
  resource "craft-cli" do
    url "https://github.com/canonical/craft-cli/archive/4af19f9c0da733321dc754be1180aea28f3feeb1.tar.gz"
    sha256 "c568748b7e6b114af7d4ecfc90a1705dc40ee665fc059f0997c2cb3138053177"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"charmcraft", "version"
    system bin/"charmcraft", "help"
    system bin/"charmcraft", "init", "--author", "Foo Bar", "-p", testpath/"charm"
    assert_predicate testpath/"charm/charmcraft.yaml", :exist?
  end
end
