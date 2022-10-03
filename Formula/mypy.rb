class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/0d/75/a1ec1af4153f7b7ae825705ada667bf445418277153c76972ba0ad782bb9/mypy-0.982.tar.gz"
  sha256 "85f7a343542dc8b1ed0a888cdd34dca56462654ef23aa673907305b260b3d746"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daab07d6dd23ca885a23c8bcf9c8d17098194b1a65af14d618ca72f9e29e1bad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a80a46b5cb16a44ba3fc31e89c2615c04c7c255020cf6f9a89488b68b4ecdb6b"
    sha256 cellar: :any_skip_relocation, monterey:       "b8885dbdc3010a3755ed5ea651e0dd2aa7ffb07301cca483daf0b4b9601e9a6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "990d4722871b5c59d820b8e50fcf3637d8a00c01636a77dc664e8991964d725e"
    sha256 cellar: :any_skip_relocation, catalina:       "d469b29cad60a945d9470e81f4eb3864458d88b73b3a4a0ba22be86757e7149b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf9b67760df268191f9ca95f7d5b0aa781f2bc401a0a6534cbf13ee7ca072f4"
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
    url "https://files.pythonhosted.org/packages/9e/1d/d128169ff58c501059330f1ad96ed62b79114a2eb30b8238af63a2e27f70/typing_extensions-4.3.0.tar.gz"
    sha256 "e6d2677a32f47fc7eb2795db1dd15c1f34eff616bcaf2cfb5e997f854fa1c4a6"
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
