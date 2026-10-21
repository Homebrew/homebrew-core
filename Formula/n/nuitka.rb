class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/da/0f/db5cfdebf906a6de141bfdadcd72a7417ba710ba9c9d307be185a69a7c8d/nuitka-4.3.1.tar.gz"
  sha256 "b9c87a694acc424cfffa06abf149fddbdfa85f6daac998df67411b5f4269df0f"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e3ee2cdaa810e3043a013f82783e2b163139df597b01624580117fe0eb5f0ccf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "845c265f64000e6043d249270616cebcdbd90698a0d7edaa84bc255b1c990e94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1b16239458578a145943b9070e7433aa99416d37281ed4b4a9a97d14627a2fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a2799a9d162d57822c3ca7dca83b036bdab161f3e73a6404d623d6fca7a55cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "524efe44991331de4cda85ca92923fc746dc2c906a03ef91ed874d3af7ffc034"
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
