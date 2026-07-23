class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/12/af/4e516a05d3ca2eb9283e9ec45b2c02225c1514dd6da49fd3c9eaa6639370/mypy-2.3.0.tar.gz"
  sha256 "465965d41cd9a2726694e983e8ce7113259327bec798115d1e1dfa2a52fb666e"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8fb4bd2736ed9c4dd6d056b68bedb3b2c90477ca931cb4dbfd94effdede8cda8"
    sha256 cellar: :any, arm64_sequoia: "ff66fc3e241c10739a348db466e40e0047f2eb0c8a7911265d990d80558accf5"
    sha256 cellar: :any, arm64_sonoma:  "b96c9d43d1e71b959cd2a8cbbcbba16ce72395bb9e11c72dbeb2d31f5a414233"
    sha256 cellar: :any, sonoma:        "5a23623476a29244fd816a73b664b39db600c13733b0bc32eb94e2591e8bd8f4"
    sha256 cellar: :any, arm64_linux:   "c601a2a7ea82d5fd309b5c26dd7a8c126e84b2a850443f2c0f01041f5d766962"
    sha256 cellar: :any, x86_64_linux:  "6d2c66e65f898d0dcc55e3160a251ee93069cc49aceb7b2956ed1e12b4d5dc20"
  end

  depends_on "rust" => :build # `ast-serialize`
  depends_on "python@3.14"

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/58/ad/0d70a3a2d6e01968d985415259e8ec7ad3f777903f9b1c1f3c8c44642c60/ast_serialize-0.6.0.tar.gz"
    sha256 "aadd3ffcf4858c9726bf3515f7b199c7eadbe504f96028e4a87172c0da65a8fe"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/dc/2f/3908645ddddab7120b46295e541ead308109fa48dbec7d67d7a778870d60/librt-0.13.0.tar.gz"
    sha256 "1d2a610c14ac0d0750ee0a3ab8548e83155258387891caaca04def4bf7289781"
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
