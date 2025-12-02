class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/d8/fb/51df3b30b0f9b3e73f3ba6bea8b94516b16035297c4b3452aaa632a130ae/nuitka-2.8.9.tar.gz"
  sha256 "b178cd437f2110c46943b368db51d20d57d586a13f8f6323ab1be4e51e2fabf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3843745296f914fc447ad794833e5bc065645820add59313b84143c5aaac68d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "128651e5cc6d1bd82f10f9e2365ff9e864214a46fe5e123c01f1991a6747a35c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f582a07716c0d17b8a7023e29e3566b4b415e4cc85c95855d8b26716bc5b6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "17bd159c492558db4cdb1a5560235b5c3bc6089eac98b7a8c0e2346d9cb836fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57875adb7566cd846d1377dd56980af61270a3e0ede8bc91b878a19f20ed4be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a06f6ca3e71e207a6016cad7811b2eb98bcdc918008eddcf37c60bba646a7825"
  end

  depends_on "ccache"
  depends_on "python@3.13" # planning to support Python 3.14, https://github.com/Nuitka/Nuitka/issues/3630

  on_linux do
    depends_on "patchelf"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
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
    assert_match "Talk Hello World", shell_output("#{libexec}/bin/python test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
