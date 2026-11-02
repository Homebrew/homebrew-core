class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/46/19/9e0a68ea7bf6124843eaf2163430edc80569d4ce33511928e3958c960fb3/nuitka-4.3.4.tar.gz"
  sha256 "e98e0c9a3224b581cf8ec0fab92b039b90fb7fa78673550c22833a82de444b25"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05c5da58f27d6d4fa02de1b51bfd51b478496ea2ecec862890a3f89343b76ca1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e347abbb67fe3981bc51b0ec7d588de519bbcbaf78a83f1e181eee7b61e2045"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0b61f1d26cdcd66b2610a87206a2ff3a3f7faa22909532fae38fbbd10ee3c4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b65b8d19a7a037a4a86d2d00c21d6d1e4bc5150c5a1724e519d551e617446e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "eaccf9346e57bc7751e1d379851a98cf36269e230435448758acf0d24664bc5e"
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
