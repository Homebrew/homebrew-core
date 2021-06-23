class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/33/46/b5d01f8844c84772e950bfc6adcaaa94cd22fedeb7c01776fd6effb3c2f6/mypy-0.910.tar.gz"
  sha256 "704098302473cb31a218f1775a873b376b30b4c18229421e9e9dc8916fd16150"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c08365f466c9d27053ffe3551dd9511fe551e6f83cb380715794b15e87ef59a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4d7bf6b83329484ba963903f474f2cf2b020800edff593e8de4ebf1df56c7ae"
    sha256 cellar: :any_skip_relocation, catalina:      "9ff4fa4cd983eaf963f2eac420bdc73912bd77bd4d0b2a471b0dcb0cf72942e5"
    sha256 cellar: :any_skip_relocation, mojave:        "50b7730ac35e1a23a145ef8dd65fea31a18943d40a2e18653284214a165faacf"
  end

  depends_on "python@3.9"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/aa/55/62e2d4934c282a60b4243a950c9dbfa01ae7cac0e8d6c0b5315b87432c81/typing_extensions-3.10.0.0.tar.gz"
    sha256 "50b6f157849174217d0656f99dc82fe932884fb250826c18350e159ec6cdf342"
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
