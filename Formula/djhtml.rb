class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/68/4d/0df3e733e56b6e5c81260d77d8d3c1776c9fa19a188deda801f63b304869/djhtml-2.0.0.tar.gz"
  sha256 "7f58b7f7ab0bc3f7a2ae2a9639a3684929bbe85f3aed34404285eacdb4e47300"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5302f47b0d9a7700a921619fdb797a8062a61bfca729803dc1af3d2c27e32d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b79f459b6653098a162763f27199b50e28666f5ecb2b4a2b8f08420b2991a6e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4042e0f7bfa1f54c796708a5b8fda6aa88186357368094d5630220e0a29f7fb3"
    sha256 cellar: :any_skip_relocation, ventura:        "c38692e824245be0c473f0fe88d5c3d2df5e4d9d6dbff3595959f92d7a8f19ae"
    sha256 cellar: :any_skip_relocation, monterey:       "46d945f4a39aba5fa67ace241b2ef2f7f6d355dc11fe56cad8b26d4a39a3cecd"
    sha256 cellar: :any_skip_relocation, big_sur:        "465c3c698427580db16e15f5e7f0f6a75eeb5551467a6cb23854ef972c2e8297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "900134b0c49a9a9a900ca3c6357efbf7dc10da5410459b05072363d10f9af0b8"
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
