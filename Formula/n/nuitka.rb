class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/dc/2b/b88531a2735ac05346bffd9a106a45a02c81bcb34d6f5de518a488d53900/Nuitka-2.6.9.tar.gz"
  sha256 "50e1d2fae48c32b0103850df5ad2ccdde7f3c736545681c0896a5ce233597a5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23880f776dca541ee9fd6712b432f240c7e30a45948edd9672cfa358646bb18d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6d6e0ae25f51fdbe55e9cbcea852802ea8cc0bcf0a990e2e0dce3255a73437e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a80b5946706c15115b4fc6735e2dc253f103d8f2a02be2a91182d2fbf16064b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "45318fba7a8320fc0a4f1a83d6faf9a674dd8dc9adac1e9050332131694de01b"
    sha256 cellar: :any_skip_relocation, ventura:       "aa4d62f97c733f3a0c1ef9ea8690844733e9017c5a00238c1b173bec0c08555d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eab8e120765d074929bdc249fd8d0c66bfed842a381f8387b6eb5b945ed72bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "011682b6279cc07756cf03f49842e4ee4ae023eb227d8ead30568a996ab75649"
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
