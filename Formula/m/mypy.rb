class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/c0/77/8f0d0001ffad290cef2f7f216f96c814866248a0b92a722365ed54648e7e/mypy-1.18.2.tar.gz"
  sha256 "06a398102a5f203d7477b2923dda3634c36727fa5c237d8f859ef90c42a9924b"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1a565cd88850880254df5487c0adcb661a2948e171ffc4a25b63b605a9f34df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eb568f7b276e30bbb94b4303fea4053deb2571902e092fdce0c6dc6ccbbcde9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13051edf8634fe913d21eee8a2971be403a0e0256234fee04e1d60ae9235ec67"
    sha256 cellar: :any_skip_relocation, sonoma:        "79b9aeb0e6981dc39a7e9d3cd8ab2310affbdf3512a8871b94f1ad2fa29d3130"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa07396fe9463ad9f3f02e00fd53840bbfadcc145fc5d76c6c1b9b300f3fa301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d63a6d0c6b0718a03a22d985f0804d87e76883fc205c4a42622f2dbbdf4dfd6"
  end

  depends_on "python@3.13"

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
