class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/f8/5c/b0089fe7fef0a994ae5ee07029ced0526082c6cfaaa4c10d40a10e33b097/mypy-1.20.0.tar.gz"
  sha256 "eb96c84efcc33f0b5e0e04beacf00129dd963b67226b01c00b9dfc8affb464c3"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "673aa98267e8de471483db85da510e8adb09970a3688ea2ae0509fa799a7b367"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99790247a6dac34cc369013de5abd987ea5bf8aca3955d9378785a2a0dff80e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eed247ce0763b97376387ac1a155e808586ddf2b430394b90a890054c2ca59a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5909950a0a3e4ffd94eb49b7a33df550700853632f009693c8bd3f1bf7a568ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfdd272d962a11a9929ce9027a18359d6818ef5ac4af2dd651cb7c1d02aa1ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762625b22ce0af23e328dae50d889488a20c3ca0c37bb8828d2102fa9ac1b66d"
  end

  depends_on "python@3.14"

  resource "librt" do
    url "https://files.pythonhosted.org/packages/56/9c/b4b0c54d84da4a94b37bd44151e46d5e583c9534c7e02250b961b1b6d8a8/librt-0.8.1.tar.gz"
    sha256 "be46a14693955b3bd96014ccbdb8339ee8c9346fbe11c1b78901b55125f14c73"
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
