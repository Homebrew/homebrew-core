class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/50/82/deda400c3a6316a16d6e16f83534ee237cc31d11bdc3c4b96893f3f6209d/nuitka-4.4.tar.gz"
  sha256 "e38d9d1efbf50fb50166384ef8378370fd67e3b755a6fea2c82e0a06b9cd0d6b"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    manifest_sha256 "1c47ddb2f4562959c132d56a040e799f8403de0ac217b2fe46c272482e10be46"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2cfb6e2c837b4a28bfb42ad9470bc4941fdcb9aa0169317f0582096920a8630"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ff97f695d7fb07a46af2bb56cf9bdec485f3270e9ad5843c06ff4238bd1cc96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2ae7d9bea8e5abcd38deaf4570a830520105790c5dc9406f10a46ab0936b95a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "48f2bbb584b24a458a94e994a22e55ac4ce0ade0aadbbb09405c381f880d3b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "68a9049078028f92bae92096b8c58a36dbaed279687c466d14be682bc727cf69"
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
