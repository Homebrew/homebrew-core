class Llm < Formula
  include Language::Python::Virtualenv

  desc "Access large language models from the command-line"
  homepage "https://llm.datasette.io/"
  url "https://files.pythonhosted.org/packages/7d/f2/3a81744fdaf3a92fe9020dc298dd2e4c144e2e7fcab863e1a132ea537cab/llm-0.31.tar.gz"
  sha256 "c7701408fdc53cbdf1db6a43f35c7dd410c291dda36cc38a14db4b482b274fa4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d86f08f2709bcd826f81c3029673cc5c1ebc3209258035ade8844190c5f84411"
    sha256 cellar: :any,                 arm64_sequoia: "67e3c308bd04334229056b00f0483c3c6b7ca7bc56c54e2ebbcb921cb99266e6"
    sha256 cellar: :any,                 arm64_sonoma:  "805f4f03088ad5168f19b7327d793ac8e3b649ca115a426ea24e71868fe61ffe"
    sha256 cellar: :any,                 sonoma:        "d2a13c347c4a2320d23d9354487b9e3e374828bfbe8f2b201f24c97fcdc52b67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36dd265a5ba06fec0405be95176ddeb0a4dec175a0dd080a5b8f9e5a54d82852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2944210af1ec412687cdf6124d4704e242864514dec1670f8f1050229bdf522"
  end

  depends_on "rust" => :build # for jiter
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
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
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/6e/c1/0cddc6eb17d4c53a99840953f95dd3accdc5cfc7a337b0e9b26476276be9/jiter-0.14.0.tar.gz"
    sha256 "e8a39e66dac7153cf3f964a12aad515afa8d74938ec5cc0018adcdae5367c79e"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/ed/59/bdcc6b759b8c42dd73afaf5bf8f902c04b37987a5514dbc1c64dba390fef/openai-2.32.0.tar.gz"
    sha256 "c54b27a9e4cb8d51f0dd94972ffd1a04437efeb259a9e60d8922b8bd26fe55e0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
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
