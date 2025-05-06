class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/2d/c8/ff5f8ccdd112101d0026006887708083db587a02b9379ea726f8f9a93c03/Nuitka-2.7.tar.gz"
  sha256 "b0d5ad394cbfe93820116cfe94605e50bb20f5707b6fb41e09c421a7c9a2c53d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6e89f1130feee23517f07c32fa2913ac72e9ac96f2a75e65182dd58534f1934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e289f347006e30132d79b96cc0f53ed2fc812e90fb9e71878939d03a57e9d064"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44dd100cd790769f129732d4e460f78d448fb0b23f0974c4972f13a469b3cb40"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4883ef7569d2c214e3baa9ed8ce13030d6568a60678265ba61531a6e2c3445b"
    sha256 cellar: :any_skip_relocation, ventura:       "93b3e6e3c2f2faa36d23fd436eaf4c6c909977fb0265cedc8419f3573aad5bce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7257546f250957855f4e56acf3b3aa34d164bcf76121665789739d36dd07271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2fcfa47bb58c8dcc58d3b04a3e5e3c5561c2bfba69b1111acb0658489291983"
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
