class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/14/a3/931e09fc02d7ba96da65266884da4e4a8806adcdb8a57faaacc6edf1d538/mypy-1.18.1.tar.gz"
  sha256 "9e988c64ad3ac5987f43f5154f884747faf62141b7f842e87465b45299eea5a9"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92046a96f5d020516c11cf9d81631a1b0363d84fd44e0a7cba497077baff51b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e95e2d05a581eaa635c0988479606576bf24dc006a26e8cc4fa8d61f036b99f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cecd4945f4590ff946b7882c71dbaec8cfcc6b9a1f7535d1a443583dc940423e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c9a3b9e4158b76ff63334073f10b3b4c213515334758a64e73a2dd38cb3bdb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4476f72a82b3b7687b8a6fc4c2d565c43efb8a5d6e32fc58a7595ae5bc36dcde"
    sha256 cellar: :any_skip_relocation, ventura:       "38206f984a771860c08a93ab3b999772e31f3323fadd6ca68b62f2a466f2ac50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f651e99681fca02b9ed3e84eae46e7fc303d38f1070c57dac5a8e37a7ca0389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d3e22687b549bedc8cb4cefff9f5d79ed9ff4f23520b0ff5dbf49583d17fb25"
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
