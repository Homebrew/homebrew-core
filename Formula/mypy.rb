class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/02/7e/fb5618b53809c4c5736465eeea89bd3517f10d9e88d8f6533a7286ef15ea/mypy-0.940.tar.gz"
  sha256 "71bec3d2782d0b1fecef7b1c436253544d81c1c0e9ca58190aed9befd8f081c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "858c8530ad033982cd218f1ee394e888ba555f309ce4f43aab71e3cc3b6e536c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9ce09374b12450d81fc52301f2683416cd074a51b9dfbe66cef3567b3a9ae9b"
    sha256 cellar: :any_skip_relocation, monterey:       "8a0f39e9a551432dc1a7cec103945edc20f4796c505c1fabaacd92a5dd2bd4ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "40e9223c9717c5fdd0fc4c07b8dffe2ac7dd375812e17d85667a4ffd38bc4222"
    sha256 cellar: :any_skip_relocation, catalina:       "3b902b5125449b73f3c68d64cf8c5d3c1285ab4478825cfdb153d4d823a8d4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb2aff1fd6fff27fa4e4d06c678fcff088911833752d2162ad6af47c8bc7d76e"
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
