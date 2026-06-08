class Gitingest < Formula
  include Language::Python::Virtualenv

  desc "Turn any Git repository into a prompt-friendly text ingest for LLMs"
  homepage "https://github.com/coderamp-labs/gitingest"
  url "https://files.pythonhosted.org/packages/d6/fe/a915f0c32a3d7920206a677f73c185b3eadf4ec151fb05aedd52e64713f7/gitingest-0.3.1.tar.gz"
  sha256 "4587cab873d4e08bdb16d612bb153c23e0ce59771a1d57a438239c5e39f05ebf"
  license "MIT"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5108551300c0633539d7a629bdf4e2bef9e4584b45514d2e87c255a7ae9481b"
    sha256 cellar: :any,                 arm64_sequoia: "3209dc735bec1211ba789d54c491db75b6b30a58543a9becf003f3ea287f0900"
    sha256 cellar: :any,                 arm64_sonoma:  "754b0b2bcc2ec9fe232621adfdabdae6191daf4878278a8150e7784b8e49cd97"
    sha256 cellar: :any,                 sonoma:        "78683ca587aec2edb2301dedcafe8d7913391c6eb5047cc2c473799ae05d9079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99dabb878c0d46f8ae9c11b95d5b7dec275884a4f95d3eb7caa9524e08149c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecd6b692fbfa8423772d39ff13cf2447ded4122b8e05bb618c29920acac1d755"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
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
    url "https://files.pythonhosted.org/packages/1a/88/bcf9709822fe69d02c2a6a77956c98ce6ea8ca8767a9aadcedc7eb6a2390/idna-3.16.tar.gz"
    sha256 "d7a6da03db833450fca25d2358ac9ff06cd624577a4aea3a596d5c0f77b8e03d"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/3a/05/a1dae3dffd1116099471c643b8924f5aa6524411dc6c63fdae648c4f1aca/loguru-0.7.3.tar.gz"
    sha256 "19480589e77d47b8d85b2c827ad95d49bf31b0dcde16593892eb51dd18706eb6"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/08/a3/84e821cc54b4ab50ae6dbc6ac3800a651b65ec35f045cc73785380654057/starlette-1.0.1.tar.gz"
    sha256 "512399c5f1de7fac99c88572212ded9ddeddef2fb32afa82d724000e88b38f4f"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/e4/e5/5f3cb2159769d0f4324c0e9e87f9de3c4b1cd45848a96b2eb3566ad5ca77/tiktoken-0.13.0.tar.gz"
    sha256 "c9435714c3a84c2319499de9a300c0e604449dd0799ff246458b3bb6a7f433c1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"gitingest", shell_parameter_format: :click)
  end

  test do
    system bin/"gitingest", "https://github.com/Homebrew/install"
    assert_path_exists testpath/"digest.txt"
  end
end
