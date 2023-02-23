class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/eb/11/d59c6141c3a6f143e9e360d5d3783275d812897cab8d532568930a681861/djhtml-3.0.0.tar.gz"
  sha256 "73d36ccddccd1b1fd991fe5c20341ab2287477a94ecfd59234ae87aea79766fc"
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
