class Darker < Formula
  include Language::Python::Virtualenv

  desc "Apply Black formatting only in regions changed since last commit"
  homepage "https://github.com/akaihola/darker"
  url "https://files.pythonhosted.org/packages/df/78/ad6af1661c2eca0ec69b7ff7c99d95dcae29c5e0071c7ebc98e6670f4663/darker-3.0.0.tar.gz"
  sha256 "eb53776f037fcf42b1f5a56f62fb841cd871d95a78a388536dc91dc4355ce8bb"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2c171dadbb8488ede92f3763ecf9fd9e3a06e706363c1f4661d5394280035a4e"
  end

  depends_on "python@3.14"

  resource "black" do
    url "https://files.pythonhosted.org/packages/4b/43/20b5c90612d7bdb2bdbcceeb53d588acca3bb8f0e4c5d5c751a2c8fdd55a/black-25.9.0.tar.gz"
    sha256 "0474bca9a0dd1b51791fcc507a4e02078a1c63f6d4e4ae5544b9848c7adfb619"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "darkgraylib" do
    url "https://files.pythonhosted.org/packages/ed/f8/098b981e982f5bd4616e42409debde17783757405781c01e3fc9ead5012d/darkgraylib-2.4.0.tar.gz"
    sha256 "d270b2c5a50be3575f50d26ec22adcd934f9a7a9edcd3c5400fddf8fb1e89af7"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/30/5f/e959a442435e24f6fb5a01aec6c657079ceaca1b3baf18561c3728d681da/pytokens-0.1.10.tar.gz"
    sha256 "c9a4bfa0be1d26aebce03e6884ba454e842f186a59ea43a6d3b25af58223c044"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darker --version")

    (testpath/"darker_test.py").write <<~PYTHON
      print(
      'It works!')
    PYTHON
    system bin/"darker", "darker_test.py"
    assert_equal 'print("It works!")', (testpath/"darker_test.py").read.strip
  end
end
