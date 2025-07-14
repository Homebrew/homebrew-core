class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/9b/9c/f51b7c7dae304f2381b5af20a5ac6ccb56f0a773d16470b269146f5909db/Nuitka-2.7.12.tar.gz"
  sha256 "ee28e5699005904e83250ad1b3192cf2c5b46bebbf4ae12f6fc5efa4a0368c16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "965958e7f4c54eb2958578aa167b3ad3fcb609836df3be8ab8664ce5a4ec3fae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "626ec20b7b5ed570db288cf912c32e85044c7367caf5b356ba9341be1a24cc5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b0fbeb3dd462c4e89b233349b76a820cd94f3db667cc57a06e4bd177a65534f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7188b05b2e1d02ea28b99c4943e6ed4ed2dd4e0ed8afafa384d086517c627325"
    sha256 cellar: :any_skip_relocation, ventura:       "eb48e45ba8e69e290316d2b5b329d09e127c979e387632b1728912bb7597ee22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0504a69c8bb7ac43172c4cc6de29bd59d06eb5181010e54d52672dced6c68254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb9f041353a398a6115ae14d066db5f31bf2f326d1dad72a4fff06c72f1281e1"
  end

  depends_on "ccache"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/ed/f6/2ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1/zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    EOS
    assert_match "Talk Hello World", shell_output("python3 test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
