class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/81/69/92c7fa98112e4d9eb075a239caa4ef4649ad7d441545ccffbd5e34607cbb/mypy-1.16.1.tar.gz"
  sha256 "6bd00a0a2094841c5e47e7374bb42b83d64c527a502e3334e1173a0c24437bab"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "543a5b7ca5efa4571845cb6cd262ddc31d5186da9f6256f90a660bc85ef1a591"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc2d204cf9d644f5c644599b88107e6779dec54e117a770f96025e83052082c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7c30ed3a7765a98d9270256331b4f00d4ff94a86299b244a5f98a77e0cd6898"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e150123386ddb5596a8c61db23ca151dac6ea4abed76e5c2f1ac378ed85c26a"
    sha256 cellar: :any_skip_relocation, ventura:       "b56aa91d0724c8c5021c1730bee9e588143a6a343d17be6d2225eb85073977eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77d955ffa79b341c57fb443a15905f6cf2fb66fc7c8894068c52498deb3aa597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43d2be66f37b90b4fcf70c54109818fabcbf0e0bbc82b36e4e7139c48f49b209"
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
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
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
