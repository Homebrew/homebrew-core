class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/5f/ec/a9a448d2c429865483fdecf3e4d60e4dcdb8738085337cbd2482ec6468ef/nuitka-4.3.5.tar.gz"
  sha256 "ca1dabc274b95efa7a46597f464ec27484b30f32cb89872d14d66541284d4f01"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0188a52f9933cc7d31aa3cd93951340e58db38d97b710d4ec4aaf2b2f1b4ac70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1198a1d4fcf5bfc1542e9c4af7f3e3562ec46ac05d44fccfd9d0032f3e2f4c44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae252cd556be84cec2b78a3f2d6200bee6a725f0899ae9f41a3fcc21bfb8c340"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "54686dbab16609ab61b21478c82ce1d611040093e0bfcacc07554fa22488eb7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7b9c286eddd181faae28d5a3520ffcffff30a19071ac84f8737e173106a53b62"
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
