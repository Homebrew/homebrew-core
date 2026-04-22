class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/0b/3d/5b373635b3146264eb7a68d09e5ca11c305bbb058dfffbb47c47daf4f632/mypy-1.20.1.tar.gz"
  sha256 "6fc3f4ecd52de81648fed1945498bf42fa2993ddfad67c9056df36ae5757f804"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f02eb40ade070ca43b046f5e876f284c67f5e3fd74c149531eb76e251e08d6ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "638406801372ef5b7dc41667bfbd602df2b47b33b1d74e1c25cfa9ec2de72c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe26aa74c41eeb2f728098bc8e74b9473c98b3694673f3b3b43ceceaa31c59f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2971b2e5fbc53fe16ff9e2ae029cb40c1c5c070ba9a92f72a65afc0886597fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37a9e099d22bafe41dfdf38cb1faada42809d2e1b47e52bc89dc9ab270c6c2a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ba5442f736ae9aeda056602ad8d3d5911177f82278d27b55ab2782eb091f735"
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
