class Pocsuite3 < Formula
  include Language::Python::Virtualenv

  desc "Open-sourced remote vulnerability testing framework"
  homepage "https://pocsuite.org/"
  url "https://files.pythonhosted.org/packages/0f/05/b17921332ab312c04ccc67b3d01a0d4318a4d45eb0315531f66d41a89639/pocsuite3-2.0.8.tar.gz"
  sha256 "9508ffec49519e5421f19472a582d747b44bf3db289357ed39227e9addfceec3"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/knownsec/pocsuite3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5afdcbcbf2f59760c913954e625a2be82f702825c57b8d159054e6c9ec575d6c"
    sha256 cellar: :any,                 arm64_sonoma:   "87432dc1483b8d711f44587d434d9c378e6df53728b607f61d6161ed0b866780"
    sha256 cellar: :any,                 arm64_ventura:  "23774e53c7c6b0413b209cb4b072732cccfe9079a2191c2da5f8879e34b75ad5"
    sha256 cellar: :any,                 arm64_monterey: "78ef059feda4ca1a13c005167c4d8663c401bf89d34e007470ce8ef7b7ee790e"
    sha256 cellar: :any,                 sonoma:         "9335aa0028fc926f86ea7c09d3da2482a0a064737c07535342cae5ac7c25bb78"
    sha256 cellar: :any,                 ventura:        "b7a12dfc9a31e153e01be50ec8df9f2e60025c43ee61f75aa1fba9a3a7719d6e"
    sha256 cellar: :any,                 monterey:       "21b31e74ae7088891111b288a75af74e314e58c44bf420988eb79625eb583990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b904a94861cbbfdc9a759cbe1cc8880d3b8a9fc027814549db23911b36c53d88"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/db/38/2992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8/colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "dacite" do
    url "https://files.pythonhosted.org/packages/21/0f/cf0943f4f55f0fbc7c6bd60caf1343061dff818b02af5a0d444e473bb78d/dacite-1.8.1-py3-none-any.whl"
    sha256 "cc31ad6fdea1f49962ea42db9421772afe01ac5442380d9a99fcf3d188c61afe"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/9f/5f/54f7b76309053b4ac79060e524bb39f3828341e822d399a8c4f95e560820/faker-30.3.0.tar.gz"
    sha256 "8760fbb34564fbb2f394345eef24aec5b8f6506b6cfcefe8195ed66dd1032bdb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jq" do
    url "https://files.pythonhosted.org/packages/ba/32/3eaca3ac81c804d6849da2e9f536ac200f4ad46a696890854c1f73b2f749/jq-1.8.0.tar.gz"
    sha256 "53141eebca4bf8b4f2da5e44271a8a3694220dfd22d2b4b2cfb4816b2b6c9057"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "mmh3" do
    url "https://files.pythonhosted.org/packages/e2/08/04ad6419f072ea3f51f9a0f429dd30f5f0a0b02ead7ca11a831117b6f9e8/mmh3-5.0.1.tar.gz"
    sha256 "7dab080061aeb31a6069a181f27c473a1f67933854e36a3464931f2716508896"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/28/57/0a642bec16d5736b9baaac7e830bedccd10341dc2858075c34d5aec5c8b6/prettytable-3.11.0.tar.gz"
    sha256 "7e23ca1e68bbfd06ba8de98bf553bf3493264c96d5e8a615c0471025deeba722"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/11/dc/e66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828f/pycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "scapy" do
    url "https://files.pythonhosted.org/packages/70/ca/17cc6ee0dbf342193732312f14bfc879dd162570287fd9f65ac1eb8a9c5f/scapy-2.6.0.tar.gz"
    sha256 "c8f7eb54511c2fab502128ccf18e2e4b98e1f6af6e02ae15b84ad3039143ba3b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/37/72/88311445fd44c455c7d553e61f95412cf89054308a1aa2434ab835075fc5/termcolor-2.5.0.tar.gz"
    sha256 "998d8d27da6d48442e8e1f016119076b690d962507531df4890fcd2db2ef8a6f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  # Drop setuptools dep: https://github.com/knownsec/pocsuite3/pull/420
  patch do
    url "https://github.com/knownsec/pocsuite3/commit/cddfbdb6b7df51f985abe8db7ecd24d5d3b5a92a.patch?full_index=1"
    sha256 "b1aff714f6002b46c2687354ce51ce0f917d5d13beb20fb175f3927f673f9163"
  end

  # Fix SyntaxWarning's: https://github.com/knownsec/pocsuite3/pull/420
  patch do
    url "https://github.com/knownsec/pocsuite3/commit/2505bc8b1501866b9193398575c5653614e131f4.patch?full_index=1"
    sha256 "656929162b5ddd99ae7d98a4580e9dab8914bf0c66f23ab1d7aacb0c2b13a84c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Module (pocs_ecshop_rce) options:", shell_output("#{bin}/pocsuite -k ecshop --options")
  end
end
