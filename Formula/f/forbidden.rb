class Forbidden < Formula
  include Language::Python::Virtualenv

  desc "Bypass 4xx HTTP response status codes and more"
  homepage "https://github.com/ivan-sincek/forbidden"
  url "https://files.pythonhosted.org/packages/9b/aa/98fc3ee28aac41cae341a197858ff6af5d79e40dcd45c8a6e37b1fdbfd19/forbidden-13.4.tar.gz"
  sha256 "dc987150b71515810d7ae252895b3ca6e077a8d9b3cbb0d09dfc9797c933a14d"
  license "MIT"
  revision 3
  head "https://github.com/ivan-sincek/forbidden.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "883cf74585de84135d4b2079183a0654ad0aaf03c5a782cacaec998a8012685e"
    sha256 cellar: :any,                 arm64_sequoia: "4e1c9a6bf7ce317ac30198503cf5be4f66e8915a14d93702cdd79ab93f591ed1"
    sha256 cellar: :any,                 arm64_sonoma:  "aebdb274b5b3836ef8af70c0ca1254e606061efed569666cc06bcf5edc04aa5f"
    sha256 cellar: :any,                 sonoma:        "bde988a5ae9d23dbc8a27a9846b4ee50ef859c09748f293548ecf1f0e77d8fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f8becbbb792c9b7d44fde9ce808d553ddb0e46af8876655e0aec1853168ef97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "614219fd73d43c9afe372b9c51c75fd3e6ed167e485bf2b5f600df6b28c8fa82"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pycparser" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cffi cryptography pycparser]

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/9a/26/d43128764a6f8fe1668c4f87aba6b1fe52bea81d05a35c84a70d3c70b6f7/alive-progress-3.3.0.tar.gz"
    sha256 "457dd2428b48dacd49854022a46448d236a48f1b7277874071c39395307e830c"
  end

  resource "bot-safe-agents" do
    url "https://files.pythonhosted.org/packages/44/8e/fd72545a981a5133b51802852bdb6d5a313a330b61cec952b3455456b9fd/bot_safe_agents-1.1.tar.gz"
    sha256 "ba3405bc92de1301fdd19b48e80ba7f26a8661ebbba2ab010e80e15267075ba6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/1d/35/02daf95b9cd686320bb622eb148792655c9412dbb9b67abb5694e5910a24/charset_normalizer-3.4.5.tar.gz"
    sha256 "95adae7b6c42a6c5b5b559b1a99149f090a57128155daeea91732c8d970d8644"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "graphemeu" do
    url "https://files.pythonhosted.org/packages/76/20/d012f71e7d00e0d5bb25176b9a96c5313d0e30cf947153bfdfa78089f4bb/graphemeu-0.7.2.tar.gz"
    sha256 "42bbe373d7c146160f286cd5f76b1a8ad29172d7333ce10705c5cc282462a4f8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/e3/3d/01255f1cde24401f54bb3727d0e5d3396b67fc04964f287d5d473155f176/pycurl-7.45.7.tar.gz"
    sha256 "9d43013002eab2fd6d0dcc671cd1e9149e2fc1c56d5e796fad94d076d6cb69ef"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/c2/27/a3b6e5bf6ff856d2509292e95c8f57f0df7017cf5394921fc4e4ef40308a/pyjwt-2.12.1.tar.gz"
    sha256 "c74a7a2adf861c04d002db713dd85f84beb242228e671280bf709d765b03672b"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8b/71/41455aa99a5a5ac1eaf311f5d8efd9ce6433c03ac1e0962de163350d0d97/regex-2026.2.28.tar.gz"
    sha256 "a729e47d418ea11d03469f321aaf67cdee8954cde3ff2cf8403ab87951ad10f2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/46/79/cf31d7a93a8fdc6aa0fbb665be84426a8c5a557d9240b6239e9e11e35fc5/termcolor-3.3.0.tar.gz"
    sha256 "348871ca648ec6a9a983a13ab626c0acce02f515b9e1983332b17af7979521c5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/forbidden -u https://brew.sh -t methods -f GET")
    assert_match "\"status\": 200", output
  end
end
