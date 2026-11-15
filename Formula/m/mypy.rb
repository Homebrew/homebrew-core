class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/4a/3c/78ecece71ee4b5445389a4ccd11627cfb9c69e4de554d11060171f376305/mypy-2.4.1.tar.gz"
  sha256 "63b590965691e540a335fa74dadf31a7069142f6b72e234689bbd244edf55623"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bee3c4d12b801e8ba2af1674e81e12f5b52ebe5ac13630be79072caa7bafca6c"
    sha256 cellar: :any, arm64_tahoe:       "e37a855ce6a4e74234e3f445ccdfc5f95dada1f92279d19f17c573fd84fd6c2e"
    sha256 cellar: :any, arm64_sequoia:     "3fbce133d2be663cee53b21291f176720675e7166d9da925c6d997bc2c0199a7"
    sha256 cellar: :any, arm64_linux:       "638b18e02f4cd626f952b4dc5143223b3ee711568a1a6f1957881f46f3024b74"
    sha256 cellar: :any, x86_64_linux:      "20bc1317332437423cc07ea91af329742dab93846fb1dee92b27fb1743a03577"
  end

  depends_on "rust" => :build # `ast-serialize`
  depends_on "python@3.15"

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/21/d5/5dc1ee8a80c3b20a0b63c61b43ba6bc53517faecd1def47bcd752d22268e/ast_serialize-0.13.1.tar.gz"
    sha256 "401cc84e8888d4d76f2c8d296fa006ed1a5ff993b6aff90dd777c03973efd025"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/04/f5/9dc696772d241814bacac7880bac32f2930b5a6ebc1f85317b83161a011c/librt-0.16.0.tar.gz"
    sha256 "ac38d6d8d66bf3d744148dbbc0b8e193e195a51e364ed55e224631f5721891fc"
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
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
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
