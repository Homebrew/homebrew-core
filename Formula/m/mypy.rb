class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/cf/dc/7e6d49f04fca40b9dd5c752a51a432ffe67fb45200702bc9eee0cb4bbb26/mypy-2.0.0.tar.gz"
  sha256 "1a9e3900ac5c40f1fe813506c7739da6e6f0eab2729067ebd94bfb0bbba53532"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d80199177a5ee057b52d7f6842fd815d7089a4d66765cf37627e2cac4fdc6d88"
    sha256 cellar: :any,                 arm64_sequoia: "0ce6e5cf1642cb2875b2cfc562d4defeb9706dd6d670c8f3f5068c9a397e6afd"
    sha256 cellar: :any,                 arm64_sonoma:  "f8d29c6fa042c0469dff527835b373feca5971803ad1015cd19d25af0928e413"
    sha256 cellar: :any,                 sonoma:        "48227f37204e9a5612dff2abea4953176253a268781561fe0adc7754a28f81d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b5667f12234fe0d5d3f36716349c108ff9f9ccb24708d27c9008bd39a696c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "347466793f5232d401d88ed205ce0744b6edfb086e1d37c66182f3dc30f7bf84"
  end

  depends_on "rust" => :build # `ast-serialize`
  depends_on "python@3.14"

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/a9/9d/912fefab0e30aee6a3af8a62bbea4a81b29afa4ba2c973d31170620a26de/ast_serialize-0.3.0.tar.gz"
    sha256 "1bc3ca09a63a021376527c4e938deedd11d11d675ce850e6f9c7487f5889992b"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/39/cb/c1945e506893b5b8577fb45a60c80e3ffe4a82092a04a6f29b0b951d9a24/librt-0.10.0.tar.gz"
    sha256 "1aba1e8aa4e3307a7be68a74149545fde7451964dc0235a8bec5704a17bdda42"
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
