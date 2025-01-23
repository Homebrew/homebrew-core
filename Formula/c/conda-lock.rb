class CondaLock < Formula
  include Language::Python::Virtualenv

  desc "Lightweight lockfile for conda environments"
  homepage "https://github.com/conda/conda-lock"
  url "https://files.pythonhosted.org/packages/1c/71/13d0ad77f549d40be2697270b5b8ec1a0934a5e85e42d453fb8adede7d81/conda_lock-2.5.7.tar.gz"
  sha256 "dd85c762adbf6e235fe365630723b4ace2d7e760ccadba262263390390c49a06"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b585955227114a717f1e4b2dcb4868d9656175a65fb8da2dd22e3c7bb1ada9f8"
    sha256 cellar: :any,                 arm64_sonoma:  "cfae6edb4c19b0d2ceab2b2459bc0cd299afbee0f6dfae57c7660e3ac40eec5b"
    sha256 cellar: :any,                 arm64_ventura: "87035793e4ef882f0b363ccace49cd5dd20c5b54cf331d4f36a63e4c686d84d3"
    sha256 cellar: :any,                 sonoma:        "56045a3de8c67237e65b80421ea4ebf0fafa834b4968d9c2a229ffbf854a689b"
    sha256 cellar: :any,                 ventura:       "ba2971ee2367066731e55ba6bcb455e7cdbe866bf0f5c2bd84272d059b457946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b283174577881bdeea5f6241437c05405f56377bbe5894c906500c43e52ed5ba"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  on_linux do
    depends_on "cryptography"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/d2/23/db12e0b6b241e33f77f7cce01a06b4cc6f8071728656cc0ea262d2a14dad/cachecontrol-0.14.1.tar.gz"
    sha256 "06ef916a1e4eb7dba9948cdfc9c76e749db2e02104a9a1277e8b642591a0f717"
  end

  resource "cachy" do
    url "https://files.pythonhosted.org/packages/a0/0c/45b249b0efce50a430b8810ec34c5f338d853c31c24b0b297597fd28edda/cachy-0.3.0.tar.gz"
    sha256 "186581f4ceb42a0bbe040c407da73c14092379b1e4c0e327fdb72ae4a9b269b1"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "clikit" do
    url "https://files.pythonhosted.org/packages/0b/07/27d700f8447c0ca81454a4acdb7eb200229a6d06fe0b1439acc3da49a53f/clikit-0.6.2.tar.gz"
    sha256 "442ee5db9a14120635c5990bcdbfe7c03ada5898291f0c802f77be71569ded59"
  end

  resource "crashtest" do
    url "https://files.pythonhosted.org/packages/08/3c/5ec13020a4693fab34e1f438fe6e96aed6551740e1f4a5cc66e8b84491ea/crashtest-0.3.1.tar.gz"
    sha256 "42ca7b6ce88b6c7433e2ce47ea884e91ec93104a4b754998be498a8e6c3d37dd"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "ensureconda" do
    url "https://files.pythonhosted.org/packages/6c/64/b50777efef940be697cb83c886acf54948f3cdbf6f31e1bc48c22f874cf9/ensureconda-1.4.4.tar.gz"
    sha256 "2ee70b75f6aa67fca5b72bec514e66deb016792959763cbd48720cfe051a24a4"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b6/a1/106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662/GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/ab/23/9894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013/jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/f6/24/64447b13df6a0e2797b586dad715766d756c932ce8ace7f67bd384d76ae0/keyring-25.5.0.tar.gz"
    sha256 "4c753b3ec91717fe713c4edd522d625889d8973a349b0e582622f49766de58e6"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/51/78/65922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178f/more-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pastel" do
    url "https://files.pythonhosted.org/packages/76/f1/4594f5e0fcddb6953e5b8fe00da8c317b8b41b547e2b3ae2da7512943c62/pastel-0.2.1.tar.gz"
    sha256 "e6581ac04e973cac858828c6202c1e1e81fee1dc7de7683f3e1ffe0bfd8a573d"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/c9/a5/fa2432da887652e3a0c07661ebe4aabe7f4692936c742da489178acd34de/pkginfo-1.12.0.tar.gz"
    sha256 "8ad91a0445a036782b9366ef8b8c2c50291f83a553478ba8580c73d3215700cf"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/70/7e/fb60e6fee04d0ef8f15e4e01ff187a196fa976eb0f0ab524af4599e5754c/pydantic-2.10.4.tar.gz"
    sha256 "82f12e9723da6de4fe2ba888b5971157b3be7ad914267dea8f05f82b28254f06"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/fc/01/f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abc/pydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
  end

  resource "pylev" do
    url "https://files.pythonhosted.org/packages/11/f2/404d2bfa30fb4ee7c7a7435d593f9f698b25d191cafec69dd0c726f02f11/pylev-1.4.0.tar.gz"
    sha256 "9e77e941042ad3a4cc305dcdf2b2dec1aec2fbe3dd9015d2698ad02b173006d1"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/b1/09/a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fa/tomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/3e/bf/5e12db234df984f6df3c7f12f1428aa680ba4e101f63f4b8b3f9e8d2e617/toolz-0.12.1.tar.gz"
    sha256 "ecca342664893f177a13dac0e6b41cbd8ac25a358e5f215316d43e2100224f4d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/bf/75/53316a5a8050069228a2f6d11f32046cfa94fbb6cc3f08703f59b873de2e/virtualenv-20.28.0.tar.gz"
    sha256 "2c9c3262bb8e7b87ea801d715fae4495e6032450c71d2309be9550e7364049aa"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"conda-lock", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_equal "#{name}, version #{version}", shell_output("#{bin}/conda-lock --version").strip

    (testpath/"environment.yml").write <<~YAML
      name: testenv
      channels:
        - conda-forge
      dependencies:
        - python=3.13
    YAML
    system bin/"conda-lock", "-p", "osx-64", "-p", "osx-arm64"
    assert_path_exists testpath/"conda-lock.yml"
  end
end
