class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/3f/d8/bdb7febea4b4fe5d3d6fe2610f946771f03e792e05a5e8ec00b62c00b265/nuitka-4.1.3.tar.gz"
  sha256 "838ff8899dc2f0b652d4fcf6c5d7466cb7ad5abcb005668ac622d1e40f4d8a8d"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7da70de8ff20dfd5d1c4ae8480f40e131f051fadc8ce3347167fa88482a93ac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57779100b7bb885e6ed6761fcb543acffe6eb117aa1a359fa4dfe0b617652fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1d047cdf37ce74bc8eaf52476f93b20b0ccc92151789f2e77020fabe5003ad6"
    sha256 cellar: :any_skip_relocation, sonoma:        "38e70b566f847ecbbc7ef627032f06a1f6468f4ec6f33ad49ff971caaeddc091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abcb36ed2283a03092f425843331e4d0b5a7dfc3863d965acf1e8e81b0a53b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52e78988d548cd8491be73b809a7f3db26ab41535d1fc6b1caa905f9c92c0dfa"
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
