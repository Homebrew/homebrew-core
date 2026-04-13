class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/1c/48/e54130d57b89fc015d702e98a1a217b5757625d01a01cc07d29fd046d336/nuitka-4.0.8.tar.gz"
  sha256 "3f87e87e4d3773997944ce401145ef21461337121d39ea0fbe678274005e60ba"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "befe43b9135694541c56d510a382bd2be7d20b2dbb9af94e4e876f676f3d8c9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97cb911e7d68d00944ef2280f2d3f32f381ff14760722aae6fee5b110d1b81e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ca78c962d5b28aad31c6a341ad0b48015bd3c4b2560a379dac341f5c7c1eff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3391feede32e355d49f6398372e211dfbc4cb46881c33fe3246f76915668e752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caee19e3b03fd28990d41b447abb6bb42a2dcd3a7be0773bf6933ec3d3a8c3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d984fb267dd7d17b1519e6b8c1da074f23423c7ee598cb10c89ac46380e522ac"
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
