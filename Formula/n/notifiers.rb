class Notifiers < Formula
  include Language::Python::Virtualenv

  desc "Easy way to send notifications"
  homepage "https://pypi.org/project/notifiers/"
  url "https://files.pythonhosted.org/packages/f2/da/a8c87ce1f82ed0a3940ff80cf74c2e565ffdf1e35aa1e981856f8dd8dc4a/notifiers-1.3.6.tar.gz"
  sha256 "070d69dc34892b0675bdbca8529fb13d542f0c84052c6fef48fe2ab1d98d661f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fa52de875144dfc54c1041da99cfbf6654cb471edfc2f0db1828730adfcd2c4c"
    sha256 cellar: :any,                 arm64_sonoma:  "6216fa66cd8879557763b4c775cb63b5b94f16a515dac0e40aeee361a82a1fbf"
    sha256 cellar: :any,                 arm64_ventura: "86dd4f1a510e1db751b4bd93612516a39566ffbf415cabbf1113aa45a038605e"
    sha256 cellar: :any,                 sonoma:        "5fc77fe3f5a763b5d2541fcd51b2cd3f383dd1c56d64521f070d2aabc757e3c6"
    sha256 cellar: :any,                 ventura:       "42aaedc80583da118f4943ae7246b33bd8a0af039ce9889f48162f8048a1becd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62dd5be8edb9934ab6f9cd54e5fc8f65900bdb3edb2160daec7901921ada4d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bee56b0cdd84e545ab5db61205ec8c1c87e1c8d6ca9a592fc5df77f5863a4f3"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/cd/0f/62ca20172d4f87d93cf89665fbaedcd560ac48b465bd1d92bfc7ea6b0a41/click-8.2.0.tar.gz"
    sha256 "f5452aeddd9988eefa20f90f05ab66f17fce1ee2a36907fd30b05bbb5953814d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/96/d2/7bed8453e53f6c9dea7ff4c19ee980fd87be607b2caf023d62c6579e6c30/rpds_py-0.25.0.tar.gz"
    sha256 "4d97661bf5848dd9e5eb7ded480deccf9d32ce2cd500b88a26acbf7bd2864985"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"notifiers", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "notifiers", shell_output("#{bin}/notifiers --help")
  end
end
