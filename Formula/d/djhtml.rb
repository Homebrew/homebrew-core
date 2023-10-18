class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/a0/03/aac9bfb7c9b03604a2c4b0d474af22731ef41cb662fad07f956ae7bf0f6b/djhtml-3.0.6.tar.gz"
  sha256 "abfc4d7b4730432ca6a98322fbdf8ae9d6ba254ea57ba3759a10ecb293bc57de"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01159723cd8d83ae29f91f3848e37b2e0bf0909f4eca67ef75df675c81f22135"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "470e1ecda414ec419492fbb58d6214115ba598606a048540ce0dbd65de0ba9fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fcb5d87f8864025f516ee6885abdeb3d4e7aa30be46d8f78db92c27c8e197be"
    sha256 cellar: :any_skip_relocation, sonoma:         "eef0ea1d40f68f0b34d6890f900df4bf5205169088913795ac4e74bce8d5d474"
    sha256 cellar: :any_skip_relocation, ventura:        "9d2080d9c198bbc368549e577afb9c097cf1130e24c5be57bf74127e46bf8a7d"
    sha256 cellar: :any_skip_relocation, monterey:       "0ff5e4ac253c90cf0ad3459e9ce64e86095f3af995634f9e4eeeaa366de4b486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e0c27e8bb293c79fd0f9127141e22a2acc406bfabbc6fffcc7a3b410a5148a"
  end

  depends_on "python@3.12"

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
