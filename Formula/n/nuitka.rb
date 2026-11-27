class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/50/82/deda400c3a6316a16d6e16f83534ee237cc31d11bdc3c4b96893f3f6209d/nuitka-4.4.tar.gz"
  sha256 "e38d9d1efbf50fb50166384ef8378370fd67e3b755a6fea2c82e0a06b9cd0d6b"
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
