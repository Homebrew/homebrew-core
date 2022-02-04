class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/56/07/ea50799121005ab7f1ad6aa6e434e0ef52a74877e8097faba9eb0a97923e/djhtml-1.4.12.tar.gz"
  sha256 "e43afa8be7a4a80959c171d50c615ae1ee8ae11e4ac8e8550240759e476d5f76"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a02831c612bdbdd784b865fce16e29a07f2d9464be25073a0e8be2ad555851d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b08eae463a7080dfeb1e03e5a4a1d329e486c83d12fbd8a43a1b096d2efd3a62"
    sha256 cellar: :any_skip_relocation, monterey:       "ee4582319f7526cfdd44e9d52ec2fa450e4b95215b00054235f8a84a6435f3ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "254edd4433e48431c2fa99df7dbe0c2f2b19aa7b3afd5377dd6b53744628f97b"
    sha256 cellar: :any_skip_relocation, catalina:       "91da721274dfcc8961ddb76a8fbb710090f3a3bf96c21a137f26d2817a1df39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c6f93c3982ffd4252c0415c3648ff8a32c7d534b4b18d13d7eefd772fdd1fa"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.html").write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF
    assert_equal expected_output, shell_output("#{bin}/djhtml --tabwidth 2 test.html")
  end
end
