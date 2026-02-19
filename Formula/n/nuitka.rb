class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/bf/f2/26729cc4e2a893dcabdab4f171e43b2d082756fde1af7cde31f616fc3a31/nuitka-4.0.1.tar.gz"
  sha256 "8a8dedd549049a145e1545206a082bfbe0bc610457a71d837e560e7cf015635c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f5bcd19e53e8ab440aaa7dd416a8c133d0536ad69421c8a30db5411b25c91f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03504b7846af8f9be30dbcb7f9122ecfab430ab82f6efc411eb2609cde7513c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cfa5c8d25c06786ed6c1db4cd3490d1026554379b053b93ae8d4c67fbfb11a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d2b5153fa4e0db92c7662205a3566f6191f1fcddb69fa2e2eaadb169e6e281e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2186dfa641c91ce680a16d80e63d9eb2e45d3d2c6ba9615bbc9a51ba112eac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a3d339ad2719c39d0434149dd78e2a28ef88bf947db11e25a61dfeffdc7240b"
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
