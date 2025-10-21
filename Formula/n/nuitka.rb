class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/7f/83/b2219d7d814dfac263028a79ae6873a5aab4191beece2ad36a4770209591/Nuitka-2.8.3.tar.gz"
  sha256 "10dc85443c49e7d6e4e8d3413cdfaefe7ebf3d8f47d2bfb5324b5676c3d77b5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18cd9b75c8dc2fc25f490315c0781efe41cd1aa95458944890e8b51a3665a257"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9819c8e6522a9ca7b5cfe32bf243ae0449276f40a1377b6ef1811edbffc4ad2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f8b68223f06a239886ed6d0cae61382d477b2a57cdc61dde00c52e0e2f80e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "97832f0497ac6e092f5de8429b3e9f709f23160da8a15d18219b299657b04369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96aff6306fa575a7ef4e34fee9b19b8f309a0a17015026f2193ccb7ca9db4698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f72091627699692931c689ccc25f2560ea0ee7394462ddbc684d997d64a32d7"
  end

  depends_on "ccache"
  depends_on "python@3.14"

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
