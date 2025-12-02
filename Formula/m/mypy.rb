class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/f9/b5/b58cdc25fadd424552804bf410855d52324183112aa004f0732c5f6324cf/mypy-1.19.0.tar.gz"
  sha256 "f6b874ca77f733222641e5c46e4711648c4037ea13646fd0cdc814c2eaec2528"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b1db1b9addc619d9e00dfdf33d9d1797856f40d70e5bc675650c84c7f9d6457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff732eeee1dc705104a6d1f7feccfe25178e110220cdf73d053fc3a3446281a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04d4cd9160fd37d171149cb6127c39cab31f617a78e19398a8d49d03d8dc9082"
    sha256 cellar: :any_skip_relocation, sonoma:        "372667c102b355db956082db92284e4880e226ecc14b340a0bcfe50b762e850d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f66deae374a96a8865f5d67e520159ee5561e01587e26c6271973ed776e8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d32d569e87057c9496a4d73c53320106aa2350b49819082da211aeb05ebb4ab"
  end

  depends_on "python@3.14"

  resource "librt" do
    url "https://files.pythonhosted.org/packages/72/c3/86e94f888f65ba1731f97c33ef10016c7286e0fa70d4a309eab41937183a/librt-0.6.2.tar.gz"
    sha256 "3898faf00cada0bf2a97106936e92fe107ee4fbdf4e5ebd922cfd5ee9f052884"
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
