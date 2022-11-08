class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/96/43/f50e6a373ef3402616ef65e450e5a1ceac0073b0a3ebefb4472e257152d4/mypy-0.990.tar.gz"
  sha256 "72382cb609142dba3f04140d016c94b4092bc7b4d98ca718740dc989e5271b8d"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76e0ca491eacb6514431676e5ba8600324c5be9aeaa99c40e92e8c1a2e050367"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68d6def1c41bb87d80f114bfafbbdcb9959fffac98a3470221173863eee715a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7759203e627a56162d3738b81bc597e9d558732e7688b131e37fd37b2a6eda68"
    sha256 cellar: :any_skip_relocation, monterey:       "a5ba56368101349f0a1f31c01860c044d4f7a363f31dea2c4893fa5464274214"
    sha256 cellar: :any_skip_relocation, big_sur:        "87b16bcb39cd3ce8b85cf2773cf0b6486594d9387f1c89f7ac298d3d4ea83ece"
    sha256 cellar: :any_skip_relocation, catalina:       "a427c763249b9894beebe1cad90c96374bab93086dfb7587a0e205bf076c4f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f87562c30601ff325da15b627981c131cf20d898527d579f1e1a0cd603d73524"
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
