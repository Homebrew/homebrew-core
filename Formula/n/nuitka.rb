class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/8a/13/7ba2c0b38b974b666d3bcdded84235933880e0d5c02d889f88b42bf0618c/Nuitka-2.7.5.tar.gz"
  sha256 "37d0f8b59fbffb7c9f882f6a6410d40fb9d8f312c33951aa324f84677874e2a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c337e7460f98cac408b8f49c550f8e7ec8c2b8a2bd5e2efba6792f1a135b400"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb3390e6a0c3fd679392757a3f8ef8beaf7d01e9344c9a0074b7d350a823dd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22ede4e2c9d2aa4d8acf7c4982c4505e52b157ca873e8c1c7b3bea64ff435367"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bed4db84ecbf2423023df5cd8178612d86242562555e0dac6aa13a677818288"
    sha256 cellar: :any_skip_relocation, ventura:       "594e334051dc2f6d4bd1e0cc06df28c8ba8d7b43a052b8eec631a02a12b08e99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32fd9691d1b099526e958968fee83314639695b2e349250928d113d63244d143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "383d4c20e66e3bcc5bfbbe215e6017d4b02dd062f4353c76abc9cef221a861c4"
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
