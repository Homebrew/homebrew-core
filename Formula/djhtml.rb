class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/b6/0f/5be9e91f5e9d1c9b46831987cb0087ad760827b239359c8d1e33174183e5/djhtml-3.0.2.tar.gz"
  sha256 "f260cdfe7033b21ebc01961db7e1c8832fd5830ec9af1b0e57f3e1f58deb1bd0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23f9bf11f2f02d88247e6ab185899e942966e900bec10be3945f73c35fb67a0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f31cfd241dc93b5c43a712520e50498b4ae7f32ac69ed31ad993ae952f866bba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b6c8f2891e2b9e690dd67a15c20897aa3c2607adaa45cce952d755abcd64116"
    sha256 cellar: :any_skip_relocation, ventura:        "7b76e4ab4698b540744c66829a67cbf2098d446f170ac6e497df4c5e55971ee4"
    sha256 cellar: :any_skip_relocation, monterey:       "30923468ff1108c5580a3dd135817e815515b20121f24fcd063fcfc2ee3e776f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e812566e4cf47aea5205cd63111925d18f58340a7ab88bddcbdf64b9c3b51ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8130a6eaffec8464aede54d04839b5ab226587826f9694d8053a5ed9e8ad1e95"
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
