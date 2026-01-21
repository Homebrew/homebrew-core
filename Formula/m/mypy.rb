class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/f5/db/4efed9504bc01309ab9c2da7e352cc223569f05478012b5d9ece38fd44d2/mypy-1.19.1.tar.gz"
  sha256 "19d88bb05303fe63f71dd2c6270daca27cb9401c4ca8255fe50d1d920e0eb9ba"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3875d2fb32d436f8f678fdfa05314b505ac15d271e421b81672b35ee1c528a0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "102f98f96062193f74584db037ff5b902276e7e827cc1fcf9912f6c431f554cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc4f0f17ed1e3f8bb52c84914a3577f189f669a81c73eb836bec4bb40b501363"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a02386b625de7c50c1a97d6f2ddbf6d8b150768c589d82e9d8ef5a049af854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b2d4c49ec804c1c1dafe2a905ec331944b7a770dc1dce26175dc8ed33e8a412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97b121d058c43255715d92b58044ea0e6bd0d6cfe77d79417067387fc5032656"
  end

  depends_on "python@3.14"

  resource "librt" do
    url "https://files.pythonhosted.org/packages/b3/d9/6f3d3fcf5e5543ed8a60cc70fa7d50508ed60b8a10e9af6d2058159ab54e/librt-0.7.3.tar.gz"
    sha256 "3ec50cf65235ff5c02c5b747748d9222e564ad48597122a361269dd3aa808798"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
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
