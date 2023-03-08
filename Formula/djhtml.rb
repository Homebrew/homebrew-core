class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/a4/1d/c051aceb436d47e176ad5e1af54f5e6c1ec5076dce19ae875c9f929d205a/djhtml-3.0.4.tar.gz"
  sha256 "f1342abc1a0cacaa7b0371fdbb482d2e67b1e1071f777f1f83f6571240666315"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f56220e387d3afd11dcd214d359e05e3d8d5d26adb87c01653ae2cb8c8ad0a38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "989274f8e02ab952802e700e1aa1611b2c995548241a70bcd955db2c01bf52df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfaadde817f3b04f669f40ead2c9a6e3fe259e6938eecade025ffbc1fcaea2e2"
    sha256 cellar: :any_skip_relocation, ventura:        "c60b7b054f804eb477565f573db30f22431e354db9c49c2c3a4d3f47004b5fab"
    sha256 cellar: :any_skip_relocation, monterey:       "544669d32751a634c4d7c2d3caeda3b7f3b70f3b277009885dadbd1322e17d9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d8adc9d415a2e79730b76ab07693499ffc5869962e01051f89c6355a448793a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6cca52e25a5d6fe80af2fee8a2bcb6ab421a0a43841014f12e1fe9bef2c8ec2"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.html"
    test_file.write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF

    system bin/"djhtml", "--tabwidth", "2", test_file
    assert_equal expected_output, test_file.read
  end
end
