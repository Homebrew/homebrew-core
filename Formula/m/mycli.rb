class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/ff/c0/1137f6cee3919d32e9cf85eaee54b38a33df55fd935e4abf5cfb2cb3201e/mycli-1.47.0.tar.gz"
  sha256 "6d1564c6168882ab1125010b5c1a2c0ed0ebe16ca13a522da67f12f151234ac0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed0382dcd01f453f616a586d7ef586ac219112adf7a0bb52ebc6a2e6897edadd"
    sha256 cellar: :any,                 arm64_sequoia: "c8861b59f82f1333b6dc0b22b6427c0204891aee0962048184062c23596d661c"
    sha256 cellar: :any,                 arm64_sonoma:  "835e5677f5788d3ff5584d03702af7e71548c92328f9d8ea88723b30c3cdd66c"
    sha256 cellar: :any,                 sonoma:        "3a3f5831fe1885a1c3558df4950cdb287fe71040d6242f237fbedebbc8db56ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e3b6e51a6bba441e51fa27164bdf6f03fe2f2f7bd5ca2cc264430b8fa551ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e3330aca7e1128dbd54c43a71364aca36c3c63fe709d11cf5fc8fc4b1760a6"
  end

  depends_on "rust" => :build # for jiter, sqlglotrs
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages package_name:     "mycli[llm]",
                exclude_packages: %w[certifi cryptography pydantic]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/5a/e6/51b043e8c4ae390af61af35f73a9c2a69a26ea9cf4d061ab45c59f8e20f4/cli_helpers-2.7.0.tar.gz"
    sha256 "62d11710dbebc2fc460003de1215688325d8636859056d688b38419bd4048bc0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "condense-json" do
    url "https://files.pythonhosted.org/packages/94/b3/d784cbc05556192ea1e798cae96363835d649fe7420ff030190789645be1/condense_json-0.1.3.tar.gz"
    sha256 "25fe8d434fdafd849e8d98f21a3e18f96ae2d6dbc2c17565f29e4843d039d2bc"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/45/9d/e0660989c1370e25848bb4c52d061c71837239738ad937e83edca174c273/jiter-0.12.0.tar.gz"
    sha256 "64dfcd7d5c168b38d3f9f8bba7fc639edb3418abcc74f22fdbe6b8938293f30b"
  end

  resource "llm" do
    url "https://files.pythonhosted.org/packages/cb/91/5071c6e0e7eabbf3a95870a4b2ec0fc585e0d4d57532d305d08d6595f8a3/llm-0.28.tar.gz"
    sha256 "e3d8bcc0f016fae8aeca1d702491a1891523702983459cb66afec99d74cabfc1"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/94/f4/4690ecb5d70023ce6bfcfeabfe717020f654bde59a775058ec6ac4692463/openai-2.15.0.tar.gz"
    sha256 "42eb8cbb407d84770633f31bf727d4ffb4138711c670565a41663d9439174fba"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dd/7f/9998706bc516bdd664ccf929a1da6c6e5ee06e48f723ce45aae7cf3ff36e/puremagic-1.30.tar.gz"
    sha256 "f9ff7ac157d54e9cf3bff1addfd97233548e75e685282d84ae11e7ffee1614c9"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyfzf" do
    url "https://files.pythonhosted.org/packages/d4/4c/c0c658a1e1e9f0e01932990d7947579515fe048d0a515f07458ecd992b8f/pyfzf-0.3.1.tar.gz"
    sha256 "dd902e34cffeca9c3082f96131593dd20b4b3a9bba5b9dde1b0688e424b46bd2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/f5/ae/1fe3fcd9f959efa0ebe200b8de88b5a5ce3e767e38c7ac32fb179f16a388/pymysql-1.1.2.tar.gz"
    sha256 "4961d3e165614ae65014e361811a724e2044ad3ea3739de9903ae7c21f539f03"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-ulid" do
    url "https://files.pythonhosted.org/packages/40/7e/0d6c82b5ccc71e7c833aed43d9e8468e1f2ff0be1b3f657a6fcafbb8433d/python_ulid-3.1.0.tar.gz"
    sha256 "ff0410a598bc5f6b01b602851a3296ede6f91389f913a5d5f8c496003836f636"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/d3/28/9d808fe62375b9aab5ba92fa9b29371297b067c2790b2d7cda648b1e2f8d/rapidfuzz-3.14.3.tar.gz"
    sha256 "2491937177868bc4b1e469087601d53f925e8d270ccc21e07404b4b5814b7b5f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/86/ff/f75651350db3cf2ef767371307eb163f3cc1ac03e16fdf3ac347607f7edb/setuptools-80.10.1.tar.gz"
    sha256 "bf2e513eb8144c3298a3bd28ab1a5edb739131ec5c22e045ff93cd7f5319703a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/d1/50/766692a83468adb1bde9e09ea524a01719912f6bc4fdb47ec18368320f6e/sqlglot-27.29.0.tar.gz"
    sha256 "2270899694663acef94fa93497971837e6fadd712f4a98b32aee1e980bc82722"
  end

  resource "sqlglotrs" do
    url "https://files.pythonhosted.org/packages/87/5a/46d8efeda45be6ce1c630229455f000cafedea6129b47e6cfab39ff462f5/sqlglotrs-0.7.3.tar.gz"
    sha256 "caadc572c8a194f99d6ba44d02f9ada0110e3d47cca3330c81f4aa608f1143eb"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  resource "sqlite-migrate" do
    url "https://files.pythonhosted.org/packages/13/86/1463a00d3c4bdb707c0ed4077d17687465a0aa9444593f66f6c4b49e39b5/sqlite-migrate-0.1b0.tar.gz"
    sha256 "8d502b3ca4b9c45e56012bd35c03d23235f0823c976d4ce940cbb40e33087ded"
  end

  resource "sqlite-utils" do
    url "https://files.pythonhosted.org/packages/b3/e3/6b1106349e2576c18409b27bd3b16f193b1cf38220d98ad22aa454c5e075/sqlite_utils-3.39.tar.gz"
    sha256 "bfa2eac29b3e3eb5c9647283797527febcf4efd4a9bbb31d979a14a11ef9dbcd"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/90/76/437d71068094df0726366574cf3432a4ed754217b436eb7429415cf2d480/sqlparse-0.5.5.tar.gz"
    sha256 "e20d4a9b0b8585fdf63b10d30066c7c94c5d7a7ec47c889a2d83a3caa93ff28e"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/05/07/0b5bcc9812b1b2fd331cc88289ef4d47d428afdbbf0216bb7d53942d93d6/wcwidth-0.3.2.tar.gz"
    sha256 "d469b3059dab6b1077def5923ed0a8bf5738bd4a1a87f686d5e2de455354c4ad"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mycli", shell_parameter_format: :click)
  end

  test do
    system bin/"mycli", "--help"
  end
end
