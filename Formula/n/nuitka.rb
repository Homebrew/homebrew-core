class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/5f/ec/a9a448d2c429865483fdecf3e4d60e4dcdb8738085337cbd2482ec6468ef/nuitka-4.3.5.tar.gz"
  sha256 "ca1dabc274b95efa7a46597f464ec27484b30f32cb89872d14d66541284d4f01"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e7902bff4ac7151b8d0e6f79b856590634412b43d129b2f9198fd3af23e4b39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "90ec4d594a9a751721bb48c7178e7608c359961099410a6da67bb65d19f1d0bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e1e1b38b55c66abea9116d53d0a78bc2c2b02ea303830ed17acde83ef770132"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "90485b9086fd8c34f53b2e2d16e4018b86176363ac990cd7a3dd5a5695dc81c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1c992e070043b291802c18cadc67311240895d54aa877bf84b4d9ee27faad2eb"
  end

  depends_on "ccache"
  depends_on "python@3.15"

  on_linux do
    depends_on "patchelf"
  end

  def install
    virtualenv_install_with_resources
    man1.install buildpath.glob("doc/*.1")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    PYTHON
    assert_match "Talk Hello World", shell_output("#{libexec}/bin/python test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
