class Aqtinstall < Formula
  include Language::Python::Virtualenv

  desc "Another unofficial Qt installer"
  homepage "https://aqtinstall.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/76/19/24a588de6c25d43169d172dab47e63a63cd0d8f90e98cf86487acbf00ac7/aqtinstall-3.3.0.tar.gz"
  sha256 "9c7d85fbe7258be2d7d23fda33f8aff2e8b7536817255eaeaaf4226da8546a31"
  license "MIT"
  revision 12
  head "https://github.com/miurahr/aqtinstall.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e80f215edd2cb27ba076a73d083c89b1f697a07356420940c86319dc7c0f167"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8918e19c16866b7c6888d82f43d5d9b6832143a521d0c9f4d9ea1b81cd4ab37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a5ea813be1b89db60b8a755acdc3e24274e2699b94638f36772b29e358ed729"
    sha256 cellar: :any,                 arm64_linux:       "3664df9f4272587eb7162fa0d017a1e4145799b6daf9b4b7ca5a281be0e120b5"
    sha256 cellar: :any,                 x86_64_linux:      "bac91af61b58974586f108f9f8acd155c5be92bcca0bff95d427ec826cd7583a"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/cf/81/1546c983678a9b4e77cb4718eaedd1b2caf24a6cdbf1eb8775938d22aff7/brotli-1.2.1.tar.gz"
    sha256 "02b2f7b5a83485efe448a44ddf7983def05c3bb1dcf917d4f7154070260e13de"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "inflate64" do
    url "https://files.pythonhosted.org/packages/3e/f3/41bb2901543abe7aad0b0b0284ae5854bb75f848cf406bf8a046bf525f67/inflate64-1.0.4.tar.gz"
    sha256 "b398c686960c029777afc0ed281a86f66adb956cfc3fbf6667cc6453f7b407ce"
  end

  resource "multivolumefile" do
    url "https://files.pythonhosted.org/packages/50/f0/a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14/multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "patch-ng" do
    url "https://files.pythonhosted.org/packages/da/b6/8ea8095f964f93567bbe28709298b30104ad418b50d4217538387bf48f7d/patch_ng-1.19.1.tar.gz"
    sha256 "036a3cc00134ec53f37e92333958ee75e117f2e62a5ec2b85c7122e5e815c29e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "py7zr" do
    url "https://files.pythonhosted.org/packages/d6/31/d5469ec310b57c730785068c227caf2263391be846ae5e99488f69b394eb/py7zr-1.1.4.tar.gz"
    sha256 "7674697559bd06b697bf6e8249985cee6dc704a4b07b8e11f24d0b1695707c3e"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/14/c9/e2de4f98c21f2ff9e58047395b6a8e17701a0f2977f0e63f80948f61647f/pybcj-1.0.8.tar.gz"
    sha256 "6818270692912d47e81ccd777b7d0ed2ad3a19ef7aaead3735b38048c80bf368"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f3/c2/f5855412372e47d635599a97c00cfcf9fc40accac9436a11bf9ded19f859/pycryptodomex-3.24.2.tar.gz"
    sha256 "e4dbc29e2575365d15e272f769329106277649aea081e2119cf43d66950f8f8f"
  end

  resource "pyppmd" do
    url "https://files.pythonhosted.org/packages/81/d7/803232913cab9163a1a97ecf2236cd7135903c46ac8d49613448d88e8759/pyppmd-1.3.1.tar.gz"
    sha256 "ced527f08ade4408c1bfc5264e9f97ffac8d221c9d13eca4f35ec1ec0c7b6b2e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/95/48/21a393ff731b8f928fa4f8176f9a7ceba2252ee60a5149f25b45c292aa5c/soupsieve-4.1.tar.gz"
    sha256 "ca9abf7126667010d8f6e9b39bfc1bc3b23c8aed9bcb0f54a754dde969bb8aab"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/03/19/9590fd39a668ea0a0869493441fe65852246a3ec67616877baad98bcb039/texttable-1.7.2.tar.gz"
    sha256 "dc16ea6b35fbf5291ba6ef79d79e37d9b3ca6acd7bae3ca3450488d7c2e19c99"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  allow_network_access! [:build, :test]

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "clang_64", shell_output("#{bin}/aqt list-qt mac desktop --arch 6.7.0")
    assert_match "linux_gcc_64", shell_output("#{bin}/aqt list-qt linux desktop --arch 6.7.0")
  end
end
