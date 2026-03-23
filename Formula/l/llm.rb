class Llm < Formula
  include Language::Python::Virtualenv

  desc "Access large language models from the command-line"
  homepage "https://llm.datasette.io/"
  url "https://files.pythonhosted.org/packages/e4/5a/c882d099a623f9d9d10a2718a6179aca87e541d3f60939e751d565efda87/llm-0.29.tar.gz"
  sha256 "75256631dc8bb990253f46be315ba43f21c0350ac47b09f673024191ebcf93cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7da35e9c3543570a6d0bb672f5d5bfef648dbe0b84339ec25eb08f9737558a4"
    sha256 cellar: :any,                 arm64_sequoia: "b3021cd3af7bea40e2eb3ccfbf5e95df395e318984a8c8de0f7da64dd8fa7f49"
    sha256 cellar: :any,                 arm64_sonoma:  "416dbf599da360fad81568767b575c41b8dbf1c602ce3157bfe5e409b64f10e2"
    sha256 cellar: :any,                 sonoma:        "3b5be9ed2abd30e2b610f1c2d5fe76e4f1b30e6e5ff4bfa50a13e830c70098b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e150e4cb8be3e0280249d79c4636ba8a446cd1251d0c1c93194e3c232426ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddcf7fe5ad95f0039456a2251bb8d560331dc45b911fdeb0bf1c9bc2f5a5db02"
  end

  depends_on "rust" => :build # for jiter
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
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
    url "https://files.pythonhosted.org/packages/0d/5e/4ec91646aee381d01cdb9974e30882c9cd3b8c5d1079d6b5ff4af522439a/jiter-0.13.0.tar.gz"
    sha256 "f2839f9c2c7e2dffc1bc5929a510e14ce0a946be9365fd1219e7ef342dae14f4"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/b4/15/203d537e58986b5673e7f232453a2a2f110f22757b15921cbdeea392e520/openai-2.29.0.tar.gz"
    sha256 "32d09eb2f661b38d3edd7d7e1a2943d1633f572596febe64c0cd370c86d52bec"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/98/61/3c849a5bd7e07fc746f26ae56cf8a1b7b4c9bed12d68d9648cc903d14fbd/puremagic-2.1.0.tar.gz"
    sha256 "06beb598183c625bf9bfed70016930c2d1299e138cd07ed5d6085a7c5deaab19"
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

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
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

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"llm", shell_parameter_format: :click)
  end

  test do
    ENV["OPENAI_API_BASE"] = "https://openai-canned-completion.vercel.app/v1"
    ENV["OPENAI_API_KEY"] = "x"
    assert_match "Incorrect API key provided", shell_output("#{bin}/llm hello --no-log 2>&1", 1)

    assert_match "llm, version", shell_output("#{bin}/llm --version")
  end
end
