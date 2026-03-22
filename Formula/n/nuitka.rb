class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/0a/4b/4923ebb606657c26d53969e1d864c89f2f4a8eca7b6ab45bed66060c9cae/nuitka-4.0.6.tar.gz"
  sha256 "9c14827058faf27414b6d28f5a27ef709fd6aa9b5f04af20e01b42889ac25b5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63b59a1d7bb04786d49a05c233531616ff57c47110b0dc020be6cc9de4978020"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "137c63362768e51c4390b663531cd8cb26d215dd36a4f3b346efe533d1136325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4fcefd2a552ff506338fbed7e757ad3187698d73df52ff53e2ad88b5a0a7448"
    sha256 cellar: :any_skip_relocation, sonoma:        "73b134dbb5cbcc5af82ad1c198ea61c0dff73e9654626db9eddd163fbeb003cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e257a5f1f579b27064fb030379c9474a1ddcf66da0fad6d08c3fa6ceb0487a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4865d8f7425f88a19047ecfc1c56f100d1f482b25b2cc70a550e91c74a5f2e34"
  end

  depends_on "ccache"
  depends_on "python@3.13" # planning to support Python 3.14, https://github.com/Nuitka/Nuitka/issues/3630

  on_linux do
    depends_on "patchelf"
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
