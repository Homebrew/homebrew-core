class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/34/4e/64300736cf0a0373a27b94a91b664ee7382e36f77b0621bae6381da3e180/mypy-2.4.0.tar.gz"
  sha256 "77bdaebd452f43fcfc4cc3ba94352a3ea537cd01e3f2d0879f48673d2ec00d6e"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e6466eabdb9442edf216a2d8f57f725e2b01a0a684aa4304946dabfc1e948ef6"
    sha256 cellar: :any, arm64_tahoe:       "d76ff7d6e89aabe43e13c8f4d0d447b81b046d0d6c4fd7d9180b693f105f10d6"
    sha256 cellar: :any, arm64_sequoia:     "8156743602f9ea4e828c45812bad0469c98d652a1d78eebdb9b1ca677cbb1d63"
    sha256 cellar: :any, arm64_linux:       "0560aa423bcd0e163937457bb562962ddf4e95b032395de6085003fc59842bba"
    sha256 cellar: :any, x86_64_linux:      "ed49ba62156cc22d305ddebb8d7d72f05bfb15a5c88af99c964300e9a5b45d86"
  end

  depends_on "rust" => :build # `ast-serialize`
  depends_on "python@3.15"

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/c2/1c/7257e6ec9382843915ce475558ce4492ccb5ed39122c256bb369c27e2ebf/ast_serialize-0.12.1.tar.gz"
    sha256 "5285a390caf1c44368ae270f037f797b91427d138b7d43cad0f1fda4c83518d9"
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
