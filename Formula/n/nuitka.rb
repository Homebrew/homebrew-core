class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/10/d9/c202b2e9d91f163417b4c5167df2a71707c57175d0540a4da8b1fc06d4f1/nuitka-2.8.6.tar.gz"
  sha256 "a648c392d2a041f31c9582a68ef7c1a3a71166eaf2d344a0bb1d03f184ed3a2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85b9fdab6b49050fdb866c419b40a1d1fee2d72603f21535ff12cee06b956c10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "919af247cc56b62980ab331c7568fad02bae46fc1ae917b9b8b135f9015c58fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4260e10e804d215c839c45c1e310ef84e037f8b451800e4950fea6565ac721a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "99097d898e3971bc56d85678dce74a5886f8e0c62a027cae9e0974378a354504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69740bd828cffefa5d218bf3d24386a288c3ace939a9b65e89a206d9383afadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2d2a65938513392a6edfdf2b9d25f0231fe404317aaf23c7a4c31723bdc8f9c"
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
