class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net/"
  url "https://files.pythonhosted.org/packages/16/75/3459b5ad002f5113356da2b505ae4296f1a6579512fa75556098b2d3c6d4/Nuitka-0.9.5.tar.gz"
  sha256 "4f77dbbd581d94f55a46065cd273bbff92cc67bea4b423330b656446f6511264"
  license "Apache-2.0"

  depends_on "python@3.10"

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/a7/b7/0fe8fb6390309f29a3a76c439dd08a73c05473bbaafa7117596ded319f84/zstandard-0.18.0.tar.gz"
    sha256 "0ac0357a0d985b4ff31a854744040d7b5754385d1f98f7145c30e02c6865cb6f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.py").write <<~EOS
      def talk(message):
        return "Talk " + message

      def main():
        print(talk("Hello World"))

      if __name__ == "__main__":
        main()
    EOS
    assert_equal "Talk Hello World\n", shell_output("#{Formula["python@3.10"].opt_bin}/python3 hello.py")
    system bin/"nuitka3", "--onefile", "-o", "hello", "hello.py"
    assert_equal "Talk Hello World\n", shell_output("./hello")
  end
end
