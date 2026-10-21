class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/b6/8c/7e904ceeb512b4530c7ca1d918d3565d694a1fa7df337cdfc36a16347d68/ptpython-3.0.32.tar.gz"
  sha256 "11651778236de95c582b42737294e50a66ba4a21fa01c0090ea70815af478fe0"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "87e04d534b33b4c7ff95ead0a062d651ed0e0d31278bc9b21c04ba3d0452b660"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35b0f4d37c8fe8f11ec6197f21898ef6cc650b92fb8952be95249effefed6299"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc207441f3f0e23e22ae149b0773e047ec83b746fc86e83616326abc430b20e1"
    sha256 cellar: :any,                 arm64_linux:       "1de4ddfa6359f5a8a1adf7ed3f2e9d22968d96a14c7be12d40fdc31be13e31b4"
    sha256 cellar: :any,                 x86_64_linux:      "a43c2bc7e894d0211347302ae2ed78e9c8cc3d94747c12152c9fa2f84e5c9497"
  end

  depends_on "python@3.15"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/46/b7/a3635f6a2d7cf5b5dd98064fc1d5fbbafcb25477bcea204a3a92145d158b/jedi-0.20.0.tar.gz"
    sha256 "c3f4ccbd276696f4b19c54618d4fb18f9fc24b0aef02acf704b23f487daa1011"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/30/4b/90c937815137d43ce71ba043cd3566221e9df6b9c805f24b5d138c9d40a7/parso-0.8.7.tar.gz"
    sha256 "eaaac4c9fdd5e9e8852dc778d2d7405897ec510f2a298071453e5e3a07914bb1"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end
