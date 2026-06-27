class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/82/15/cca9d88503549ed6fedeaa1d448cdddd542ee8a490232d732e278036fbf2/mypy-2.1.0.tar.gz"
  sha256 "81e76ad12c2d804512e9b13240d1588316531bfba07558286078bfbce9613633"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b4e27bda5c117f5786d62f87042cb4cc09fa157c8ca1ba81bf671a4ee2fda6c"
    sha256 cellar: :any,                 arm64_sequoia: "8b60529e79c0d2bf761bd24eed0b3ecddc0042785acdfe8c03ac0e87c2ed27d8"
    sha256 cellar: :any,                 arm64_sonoma:  "11fb499db8ef1cfcf046719e0228513518158436f73e62fd666c9e646b3f0fdd"
    sha256 cellar: :any,                 sonoma:        "da220ecc8469cf6e8df4c0bb0485831831d3e9ce17e51667700bc037641c10a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "369b00cf01a17f271f59ff28cf14ffed9232477d8e19e52f1ac0dc8d3b5e67be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ac61924167067c66692337a323729b0a275e63e01353a8f9a791a43e453c07"
  end

  depends_on "rust" => :build # `ast-serialize`
  depends_on "python@3.14"

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/a9/9d/912fefab0e30aee6a3af8a62bbea4a81b29afa4ba2c973d31170620a26de/ast_serialize-0.3.0.tar.gz"
    sha256 "1bc3ca09a63a021376527c4e938deedd11d11d675ce850e6f9c7487f5889992b"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/40/08/9e7f6b5d2b5bed6ad055cdd5925f192bb403a51280f86b56554d9d0699a2/librt-0.11.0.tar.gz"
    sha256 "075dc3ef4458a278e0195cbf6ac9d38808d9b906c5a6c7f7f79c3888276a3fb1"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def p() -> None:
        print('hello')
      a = p()
    PYTHON
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
