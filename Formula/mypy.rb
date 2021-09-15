class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/33/46/b5d01f8844c84772e950bfc6adcaaa94cd22fedeb7c01776fd6effb3c2f6/mypy-0.910.tar.gz"
  sha256 "704098302473cb31a218f1775a873b376b30b4c18229421e9e9dc8916fd16150"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b26ec8a65759403978f0380c0dcc6dcf2f08d8eaaf11eb00e6bff38fd35ca927"
    sha256 cellar: :any_skip_relocation, big_sur:       "05bb918c8d742e91231f01451d11e1d3c2a3bae29f30cbc483a40d32d1b4c908"
    sha256 cellar: :any_skip_relocation, catalina:      "05460595d3671e0afc0a6af784a44a0c67891d77974e1f0fd85c890d4bcb0592"
    sha256 cellar: :any_skip_relocation, mojave:        "f199a383e494c3585d2cdca8e745053898c33dfa2993fd3320fdeaf2a7142816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d0f6cc419325dd59b6a6a7fe4f79bc47e645dd3d96d131d46a4f9491d9d07af"
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
