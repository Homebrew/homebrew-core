class Llm < Formula
  include Language::Python::Virtualenv

  desc "Access large language models from the command-line"
  homepage "https://llm.datasette.io/"
  url "https://files.pythonhosted.org/packages/98/ce/74e7e92cf75a22cdb220dca230e8ba630ee720ecf2e68139dba8765fc442/llm-0.38.tar.gz"
  sha256 "cae379f24c5c6965381464c3a1be577f90a48d04c51e562b2090162bb3f893bd"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "2436262d070633735025a56ea5e67a9a9575d8fa49feb152af9b2e8320ddaf8c"
    sha256 cellar: :any, arm64_golden_gate: "b35cea15e338f734b59d7cc6c25f36a6b96d85483bacdc14ad91c14fbc31c6e1"
    sha256 cellar: :any, arm64_tahoe:       "290fc8aa5758fcd33b57c060ad25d14f13e7ef43b7e1abecb632b055e3d5119a"
    sha256 cellar: :any, arm64_sequoia:     "a8db55af42a426e8f13a40ffadba4d56a30acf1b0143d247a90acf2a788032bb"
    sha256 cellar: :any, arm64_linux:       "623bf89d5df48db2edabcfb1e7811a1ba4e4301e172dbefdd93dfb68db982d00"
    sha256 cellar: :any, x86_64_linux:      "aad5e52bb6139054f656a8c0d8565bec04e2f6139e898f147fd0725e940be072"
  end

  depends_on "rust" => :build # for jiter
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "condense-json" do
    url "https://files.pythonhosted.org/packages/d1/a5/7158b674fa5b890d80faaf42dd438d1a765661cd22430ddf499759cf44e1/condense_json-1.1.tar.gz"
    sha256 "c455b54bbbab89a69f598b09f2003a89b738df20d30e6aa341c495401ec5b349"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/92/9d/df40b41f7db0370f82019820709244e7b660c52aa3da3c9e5c4e8141f6e6/httpcore2-2.16.2.tar.gz"
    sha256 "6c519d0f7b44f7269fa9bbb4d2763db395a4a2370f046d8e8e0a4b38227815d2"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/1c/77/6515121dc5ac3c743ad1bff5afe635bcd1a3f23cc40db3c5c89f7d02917d/httpx2-2.16.2.tar.gz"
    sha256 "748b615678f07d8e3b183efe81ad13b655ca88bfc56ce4589219b2d442860574"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/67/de/8dfd06a2153d8ab6a83a8ca8f8ae3ff860ce2fe324ee6a5d05294b621c2a/jiter-0.19.0.tar.gz"
    sha256 "ba3064f8be276d7cfb83c2fb85c858be533da2c2f80f9b048c3781b45a57a195"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/6a/43/f2e44205e33d648482eac6696951e2e34b2566e8f958d0926a5a9458ab2e/openai-3.53.0.tar.gz"
    sha256 "ade02e38795eec9a8aae5336d38bce30a68aea5095a4d92b7c285ed0ceb1d4c6"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/a7/8d/4d60110e23f445e2dc106340f9bd5f422bb6c540f4fb21086d3ee44b52ab/puremagic-2.3.0.tar.gz"
    sha256 "b54e4a69dd37c50bacc879380f132382ab4e9a935529628c8975abcc73e10640"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
  end

  resource "python-ulid" do
    url "https://files.pythonhosted.org/packages/f4/5a/ccca42a406a2b71cb359371c2692a326511b870c6b09ce12b6ee58c143a8/python_ulid-4.2.0.tar.gz"
    sha256 "b935122d37ccb12afc45314019a0c0a59dba46a9e7ac722764c9be2540378c58"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  resource "sqlite-utils" do
    url "https://files.pythonhosted.org/packages/7e/6b/4a7b3d20c92e6c7acedc96ef620df8e1ea8f94a26a41ab788c1c08055815/sqlite_utils-4.2.1.tar.gz"
    sha256 "76114b6a5414714e6c70e5fa5c4781b301b590f6951b5da39c8cc60c21382ba1"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
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
