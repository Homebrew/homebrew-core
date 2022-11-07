class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/96/43/f50e6a373ef3402616ef65e450e5a1ceac0073b0a3ebefb4472e257152d4/mypy-0.990.tar.gz"
  sha256 "72382cb609142dba3f04140d016c94b4092bc7b4d98ca718740dc989e5271b8d"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bafc73da7c6b7df5f5b17cee8cda16fcbd4239cd4851b51ec1f343650f3ad85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9c3c5678cfde9d8e68fb0a9253baf6646f94ba8a4054050e3f4d9b3fec19618"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "160e7219d6314ee026c62b60bd3023bb4c440860ee18723191656837a19c8ad6"
    sha256 cellar: :any_skip_relocation, monterey:       "e408f123cb2c67e108d8db61c9bb1ce53a2c4ab588a3c054b04afdc18177d52b"
    sha256 cellar: :any_skip_relocation, big_sur:        "05cd9b18e9b8119015aa136da5da41e3d47ed6f664c5cda10ff20ad452e52f06"
    sha256 cellar: :any_skip_relocation, catalina:       "937c66e5c0acb54192ced39d8d03b4d4d7040aff9df1768e70207e75474a3172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "202fa1a5b3bcecbb4b15513548487c269a79fce26753b066f3883b52a9cd901b"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/e3/a7/8f4e456ef0adac43f452efc2d0e4b242ab831297f1bac60ac815d37eb9cf/typing_extensions-4.4.0.tar.gz"
    sha256 "1511434bb92bf8dd198c12b1cc812e800d4181cfcb867674e0f8279cc93087aa"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
