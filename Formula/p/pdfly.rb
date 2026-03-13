class Pdfly < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to extract (meta)data from PDF and manipulate PDF files"
  homepage "https://pdfly.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/48/ae/70f161c80b3f39d8fe4ff784c78045225820d10375c81c2097c0e85ac0fc/pdfly-0.5.1.tar.gz"
  sha256 "636e9736ca3296ed69ad7e14d997813ea5a662ba7a86c77d155e343494dcc3d7"
  license "BSD-3-Clause"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c38632a2c71e29f1d15d55db2f12ec3d634f4679e200246bc9481ce5cde08e7d"
    sha256 cellar: :any,                 arm64_sequoia: "d4e48089bba4f806eb2511f9b41b0bc0630e3b0273f15f3432e8c8bf8bc3f3ee"
    sha256 cellar: :any,                 arm64_sonoma:  "0dc4ee4492ce6f26441d21c225c1f8cda6cc29d3ace9a2d536b6bb84f0aa0017"
    sha256 cellar: :any,                 sonoma:        "59c7947560b977a40f5cfbc7d056391884f51057e119569349459d3b06f8ab56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d3ef8759762d6b3628838641473056b46497da1b6ba2b7444b73b842d9c88a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558b63f6aaaf45937e044a37cb4b34181637affd63dcbcffdcd5f6d7cb7b6b57"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for bcrypt
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "m4" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography pillow pydantic]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/1d/35/02daf95b9cd686320bb622eb148792655c9412dbb9b67abb5694e5910a24/charset_normalizer-3.4.5.tar.gz"
    sha256 "95adae7b6c42a6c5b5b559b1a99149f090a57128155daeea91732c8d970d8644"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "endesive" do
    url "https://files.pythonhosted.org/packages/a0/c3/a0dcae019de40816352462371c473b22639cd8e68f33a5f23f07faf330fd/endesive-2.19.3-py3-none-any.whl"
    sha256 "e5e09c1011b1977fbb9d563d672de7f17f5638304ce57a35bf7d00f3b7a3972e"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/5a/96/686339e0fda8142b7ebed39af53f4a5694602a729662f42a6209e3be91d0/fonttools-4.62.0.tar.gz"
    sha256 "0dc477c12b8076b4eb9af2e440421b0433ffa9e1dcb39e0640a6c94665ed1098"
  end

  resource "fpdf2" do
    url "https://files.pythonhosted.org/packages/27/f2/72feae0b2827ed38013e4307b14f95bf0b3d124adfef4d38a7d57533f7be/fpdf2-2.8.7.tar.gz"
    sha256 "7060ccee5a9c7ab0a271fb765a36a23639f83ef8996c34e3d46af0a17ede57f9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
    sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pykcs11" do
    url "https://files.pythonhosted.org/packages/22/07/0c2215cb6ef70c213892571eb015e670f4d6adbecedc5eb2369f82c1c7f2/pykcs11-1.5.18.tar.gz"
    sha256 "12fd878b369821d80c1be8a140c85e8a0fb1358fcaaba66ca66869213692f227"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/b4/a3/e705b0805212b663a4c27b861c8a603dba0f8b4bb281f96f8e746576a50d/pypdf-6.8.0.tar.gz"
    sha256 "cb7eaeaa4133ce76f762184069a854e03f4d9a08568f0e0623f7ea810407833b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/f5/24/cb09efec5cc954f7f9b930bf8279447d24618bb6758d4f6adf2574c41780/typer-0.24.1.tar.gz"
    sha256 "e39b4732d65fbdcde189ae76cf7cd48aeae72919dea1fdfc16593be016256b45"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    # Turn on shell completions option
    inreplace "pdfly/cli.py", "add_completion=False", "add_completion=True"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pdfly", shell_parameter_format: :typer)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfly --version")

    test_pdf = test_fixtures("test.pdf")
    assert_match <<~EOS, shell_output("#{bin}/pdfly meta #{test_pdf}")
      ┏━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┓
      ┃          Attribute ┃ Value              ┃
      ┡━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━┩
      │              Pages │ 1                  │
      │          Encrypted │ None               │
      │   PDF File Version │ %PDF-1.6           │
      │        Page Layout │                    │
      │          Page Mode │                    │
      │             PDF ID │ ID1=None ID2=None  │
      │ Fonts (unembedded) │ /Helvetica         │
      │   Fonts (embedded) │                    │
      │        Attachments │ []                 │
      │             Images │ 0 images (0 bytes) │
      └────────────────────┴────────────────────┘
    EOS
  end
end
