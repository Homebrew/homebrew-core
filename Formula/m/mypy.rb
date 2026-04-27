class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/04/af/e3d4b3e9ec91a0ff9aabfdb38692952acf49bbb899c2e4c29acb3a6da3ae/mypy-1.20.2.tar.gz"
  sha256 "e8222c26daaafd9e8626dec58ae36029f82585890589576f769a650dd20fd665"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8f66c004c46b290aee67b96b79499d6731df5f10564cf302603b881ca27f977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e3a40bbf3f682c6a83f6f04067d74b4b53ee028a5ae0831bd4b814d92da2ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8852b4b2b9c8f8a2d68034d613142acacdc62f9234a530d3c9472e86c5df3f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3080a7f777f708a6d1932855253f6c2e57d6877f05e989064bce7c74d2ffdd59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5816648406ba32738478cfa6ea276973f08ed98997b1f20171fccba9df998872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2c760acfb151eed290d854c0f3fbd3ac61b20ca0aab88f3e0d1289af4e1157"
  end

  depends_on "python@3.14"

  resource "librt" do
    url "https://files.pythonhosted.org/packages/eb/6b/3d5c13fb3e3c4f43206c8f9dfed13778c2ed4f000bacaa0b7ce3c402a265/librt-0.9.0.tar.gz"
    sha256 "a0951822531e7aee6e0dfb556b30d5ee36bbe234faf60c20a16c01be3530869d"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
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
