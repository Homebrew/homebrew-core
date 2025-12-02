class Aqtinstall < Formula
  include Language::Python::Virtualenv

  desc "Another unofficial Qt installer"
  homepage "https://github.com/miurahr/aqtinstall"
  url "https://files.pythonhosted.org/packages/76/19/24a588de6c25d43169d172dab47e63a63cd0d8f90e98cf86487acbf00ac7/aqtinstall-3.3.0.tar.gz"
  sha256 "9c7d85fbe7258be2d7d23fda33f8aff2e8b7536817255eaeaaf4226da8546a31"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30909cf4a345708b0bc6e06b9d528cd328d27e725f4c9e118147d6e45e9fe905"
    sha256 cellar: :any,                 arm64_sequoia: "3fa8448f74e8b9fd2a55594ce42d74dfdec9e0c5dec33bf44916969118f8554d"
    sha256 cellar: :any,                 arm64_sonoma:  "f5a9b0c80a6d0c172996883138d3993873cb825d5ec78878b78088af847ff0a8"
    sha256 cellar: :any,                 sonoma:        "6b40325eacc9390dab88363256b95873f884620f9efc26837760708a083a56cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f44158ac6618d87baaf820f5a2a2ae799ab9b65c8385150530563ebc18eedff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36cb37d74b6e3016794765a1be454128e4ebb7a56ad96eb6ede3512f7344a862"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"
  depends_on "zstd"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/b6/43/50033d25ad96a7f3845f40999b4778f753c3901a11808a584fed7c00d9f5/humanize-4.14.0.tar.gz"
    sha256 "2fa092705ea640d605c435b1ca82b2866a1b601cdf96f076d70b79a855eba90d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "inflate64" do
    url "https://files.pythonhosted.org/packages/dd/8c/3a7ac7e1931bd1bca5f8e3687f7611083f6a79aae02b9cd6b7ce1fb4a8d0/inflate64-1.0.1.tar.gz"
    sha256 "3b1c83c22651b5942b35829df526e89602e494192bf021e0d7d0b600e76c429d"
  end

  resource "multivolumefile" do
    url "https://files.pythonhosted.org/packages/50/f0/a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14/multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "patch-ng" do
    url "https://files.pythonhosted.org/packages/65/bb/ebd7c6058dcfbf634986f9a8b3fb638f3269501c73701a48b7530042da5b/patch-ng-1.19.0.tar.gz"
    sha256 "27484792f4ac1c15fe2f3e4cecf74bb9833d33b75c715b71d199f7e1e7d1f786"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "py7zr" do
    url "https://files.pythonhosted.org/packages/97/62/d6f18967875aa60182198a0dd287d3a50d8aea1d844239ea00c016f7be88/py7zr-1.0.0.tar.gz"
    sha256 "f6bfee81637c9032f6a9f0eb045a4bfc7a7ff4138becfc42d7cb89b54ffbfef1"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/ce/75/bbcf098abf68081fa27c09d642790daa99d9156132c8b0893e3fecd946ab/pybcj-1.0.6.tar.gz"
    sha256 "70bbe2dc185993351955bfe8f61395038f96f5de92bb3a436acb01505781f8f2"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyppmd" do
    url "https://files.pythonhosted.org/packages/f6/d7/b3084ff1ac6451ef7dd93d4f7627eeb121a3bed4f8a573a81978a43ddb06/pyppmd-1.2.0.tar.gz"
    sha256 "cc04af92f1d26831ec96963439dfb27c96467b5452b94436a6af696649a121fd"
  end

  resource "pyzstd" do
    url "https://files.pythonhosted.org/packages/47/82/7bcafbf06ee83a66990ce5badbb8f4dc32184346bab20de7e468b1a2f6ec/pyzstd-0.18.0.tar.gz"
    sha256 "81b6851ab1ca2e5f2c709e896a1362e3065a64f271f43db77fb7d5e4a78e9861"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    venv = virtualenv_install_with_resources without: "pyzstd"
    # We need to build separately to link to our `zstd`.
    resource("pyzstd").stage do
      system_zstd = "--config-settings=--build-option=--dynamic-link-zstd"
      system venv.root/"bin/python", "-m", "pip", "install", system_zstd,
                                     *std_pip_args(prefix: false, build_isolation: true), "."
    end
  end

  test do
    assert_match "clang_64", shell_output("#{bin}/aqt list-qt mac desktop --arch 6.7.0")
    assert_match "linux_gcc_64", shell_output("#{bin}/aqt list-qt linux desktop --arch 6.7.0")
  end
end
