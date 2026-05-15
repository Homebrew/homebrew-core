class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/53/db/b7a344ad688cd6d8547746869f904b105674ff529a24fa5a3d7bdd95560a/nuitka-4.1.tar.gz"
  sha256 "99092d26f5f8d5264186924451f7df5872bf6a922297062ace2798ecec7cfa0f"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57b541f6cc52eb0827dfc3ecf23b9b9384ce3c5fa5103b697ba6bda93ca9e194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e1fe2639540c827782a46e354ea241292be992f2ba2afbc0e11382afc6f0bf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4b355cf2f9c686f358921709bfe2507de2711775d97c42157244ddb9dfafdc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "702661acbbf244df64f69a2f3e26e4cf6fa472d60c81360d448a5f6bbe56c04d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332866b7588778724bd8acd48d1273086476aa33755f8d6d0f1dfcf088c1dda8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c72102a38039df1bba16c79b165803a71034896fb184c4d7c5440e1a21d3be5"
  end

  depends_on "ccache"
  depends_on "python@3.14"

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
