class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/e5/87/36bae02fb19e98cdfa5778faf14f90acff396b9b17586355fbefbe971631/Nuitka-2.7.16.tar.gz"
  sha256 "768909faf365b21ae4777727fc4ae88efc29239c664bd177061fc907e263e0fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b62f975c162f10c6d662f116546f449eb507e98f6d75ef3cf9d50ae61e02c1f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84077c8bc6b3a6ea80867a55819e23f3c9315fa1744e93b1ef5aac781a6280ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b69dea4e4b6dfd35c49f514de65179d8211be58fc11fe0f02922c340b9f83ac5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dfd6dfd0e8e197392c60d51760d37b186b29bc8755a896e466e40cc98617ecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52e8a00fac53e0acfebc340bd78b3e2d143d7ff2957ecedd7e161a7d9e41267a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7564625ab233bf99ac7b5ff8b23494adf244c135e82a635a1d91e4acd819d77e"
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
    assert_match "Talk Hello World", shell_output("python3 test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
