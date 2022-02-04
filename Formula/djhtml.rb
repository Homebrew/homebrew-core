class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/56/07/ea50799121005ab7f1ad6aa6e434e0ef52a74877e8097faba9eb0a97923e/djhtml-1.4.12.tar.gz"
  sha256 "e43afa8be7a4a80959c171d50c615ae1ee8ae11e4ac8e8550240759e476d5f76"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e04a48f43a64028115a6a14dfde11824cf9a3181e40b8ce929ab5e08d6bbdf66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "553fc7b0c2411d9b30323be4a6d12bb2994c653d2241a265148c13c2f3897037"
    sha256 cellar: :any_skip_relocation, monterey:       "aa8d7b3922352cfb278b7d446679e8b313f97264e891bd649987d254665659ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f791a9488d76a1832ec8dccabffdf2d2a3c8c6330bd9da170f5f9c74a480c6b"
    sha256 cellar: :any_skip_relocation, catalina:       "1bd9ed4731b44bb2be813485e61f10a13b65c46576eb7b7625ca3f87d5f9fc31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037954f3806f19c908e77c9271a24631e41b3a580cde652a32344c50760ac690"
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
