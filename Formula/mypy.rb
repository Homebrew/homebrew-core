class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/02/7e/fb5618b53809c4c5736465eeea89bd3517f10d9e88d8f6533a7286ef15ea/mypy-0.940.tar.gz"
  sha256 "71bec3d2782d0b1fecef7b1c436253544d81c1c0e9ca58190aed9befd8f081c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19560f740bae822c5b5a6430538aa9f14399749cbb465d786e8cee1915e2bbc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5313ed2cd5b3b4396993eed603759c32f23dc826a01855d26af002bb06345e5b"
    sha256 cellar: :any_skip_relocation, monterey:       "f46562646480761daa5f8ef749346dbb013cac158bd73503b60e6624d3de9e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "24e64862e3f6ac8372365d23b4b89921e00b36dfb3a7a4c1635b0eef6ed4b019"
    sha256 cellar: :any_skip_relocation, catalina:       "cf3dc1cc55d2e29d1c3956d7a2111bd589d441d8c44b257666ffe35b0bec212a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da3ec090ece5e64e988d5a8d8a4937a17f3a4521404a304734d825c3c90305c8"
  end

  depends_on "python@3.10"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/b1/5a/8b5fbb891ef3f81fc923bf3cb4a578c0abf9471eb50ce0f51c74212182ab/typing_extensions-4.1.1.tar.gz"
    sha256 "1a9462dcc3347a79b1f1c0271fbe79e844580bb598bafa1ed208b94da3cdcd42"
  end

  def install
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
  end
end
