class MkdocsMaterial < Formula
  include Language::Python::Virtualenv
  desc "Material Design theme for MkDocs"
  homepage "https://squidfunk.github.io/mkdocs-material/"
  url "https://files.pythonhosted.org/packages/b3/fa/0101de32af88f87cf5cc23ad5f2e2030d00995f74e616306513431b8ab4b/mkdocs_material-9.6.14.tar.gz"
  sha256 "39d795e90dce6b531387c255bd07e866e027828b7346d3eba5ac3de265053754"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0e91741378cbf7f59a15a2b44c34cde15c7a6a5c55025e432084da8c700fe026"
    sha256 cellar: :any,                 arm64_sonoma:  "ccb033943c42c4fb467be5050f46e523b3829aedad110c556a13255416ba415d"
    sha256 cellar: :any,                 arm64_ventura: "5b22330cd379dae30cf252f9e88aee00cd977ea3d7a4e22cc1376bf6ebac016e"
    sha256 cellar: :any,                 sonoma:        "0b6ff46b2a1176b34b19260786159e7240ae628ee974446dc15bb39bb566141d"
    sha256 cellar: :any,                 ventura:       "e17adccd68c47a24e7e4710c787daed969edd5f117fe2674ce57989d454871ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ece77c6c4ed36eb494fb265e9f4eb4f560b1a735899fe567bb84b9f7b887797f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b6e1e5e768ec5bcc6ef9fd193dc80792841435f3d69a798450f54bbc23819d"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "mkdocs", because: "both install `mkdocs` binaries"

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/6b/d52e42361e1aa00709585ecc30b3f9684b3ab62530771402248b1b1d6240/babel-2.17.0.tar.gz"
    sha256 "0c54cffb19f690cdcc52a3b50bcbf71e07a808d1c80d549f2459b9d2cf0afb9d"
  end

  resource "backrefs" do
    url "https://files.pythonhosted.org/packages/6c/46/caba1eb32fa5784428ab401a5487f73db4104590ecd939ed9daaf18b47e0/backrefs-5.8.tar.gz"
    sha256 "2cab642a205ce966af3dd4b38ee36009b31fa9502a35fd61d59ccc116e40a6bd"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e8/9e/c05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4/certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/cd/0f/62ca20172d4f87d93cf89665fbaedcd560ac48b465bd1d92bfc7ea6b0a41/click-8.2.0.tar.gz"
    sha256 "f5452aeddd9988eefa20f90f05ab66f17fce1ee2a36907fd30b05bbb5953814d"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "ghp-import" do
    url "https://files.pythonhosted.org/packages/d9/29/d40217cbe2f6b1359e00c6c307bb3fc876ba74068cbab3dde77f03ca0dc4/ghp-import-2.1.0.tar.gz"
    sha256 "9c535c4c61193c2df8871222567d7fd7e5014d835f97dc7b7439069e2413d343"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/2f/15/222b423b0b88689c266d9eac4e61396fe2cc53464459d6a37618ac863b24/markdown-3.8.tar.gz"
    sha256 "7df81e63f0df5c4b24b7d156eb81e4690595239b7d70937d0409f1b0de319c6f"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "mkdocs" do
    url "https://files.pythonhosted.org/packages/bc/c6/bbd4f061bd16b378247f12953ffcb04786a618ce5e904b8c5a01a0309061/mkdocs-1.6.1.tar.gz"
    sha256 "7b432f01d928c084353ab39c57282f29f92136665bdd6abf7c1ec8d822ef86f2"
  end

  resource "mkdocs-get-deps" do
    url "https://files.pythonhosted.org/packages/98/f5/ed29cd50067784976f25ed0ed6fcd3c2ce9eb90650aa3b2796ddf7b6870b/mkdocs_get_deps-0.2.0.tar.gz"
    sha256 "162b3d129c7fad9b19abfdcb9c1458a651628e4b1dea628ac68790fb3061c60c"
  end

  resource "mkdocs-material-extensions" do
    url "https://files.pythonhosted.org/packages/79/9b/9b4c96d6593b2a541e1cb8b34899a6d021d208bb357042823d4d2cabdbe7/mkdocs_material_extensions-1.3.1.tar.gz"
    sha256 "10c9511cea88f568257f960358a467d12b970e1f7b2c0e5fb2bb48cab1928443"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paginate" do
    url "https://files.pythonhosted.org/packages/ec/46/68dde5b6bc00c1296ec6466ab27dddede6aec9af1b99090e1107091b3b84/paginate-0.5.7.tar.gz"
    sha256 "22bd083ab41e1a8b4f3690544afb2c60c25e5c9a63a30fa2f483f6c60c8e5945"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pymdown-extensions" do
    url "https://files.pythonhosted.org/packages/08/92/a7296491dbf5585b3a987f3f3fc87af0e632121ff3e490c14b5f2d2b4eb5/pymdown_extensions-10.15.tar.gz"
    sha256 "0e5994e32155f4b03504f939e501b981d306daf7ec2aa1cd2eb6bd300784f8f7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "pyyaml-env-tag" do
    url "https://files.pythonhosted.org/packages/c2/95/32c8c79d784552ed687c676924381c0dc88b2a0248b50a32f4b5ac0ba03c/pyyaml_env_tag-1.0.tar.gz"
    sha256 "bc952534a872b583f66f916e2dd83e7a7b9087847f4afca6d9c957c48b258ed2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/mkdocs"
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath/"mkdocs.yml").write <<~YAML
      site_name: MkLorum
      nav:
        - Home: index.md
      theme: material
    YAML
    mkdir testpath/"docs"
    (testpath/"docs/index.md").write <<~MARKDOWN
      # A heading

      And some deeply meaningful prose.
    MARKDOWN
    system bin/"mkdocs", "build", "--clean"
  end
end
