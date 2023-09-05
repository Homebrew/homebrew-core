class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/a0/03/aac9bfb7c9b03604a2c4b0d474af22731ef41cb662fad07f956ae7bf0f6b/djhtml-3.0.6.tar.gz"
  sha256 "abfc4d7b4730432ca6a98322fbdf8ae9d6ba254ea57ba3759a10ecb293bc57de"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdbeb839a0a9b284dc4c2eb9e3eecc74af5930ec4f9098db10c49511746e4d44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fb937a34da3f5e3a1252fa38b2d716a3868048f8cc18b1d9f00f3391450bca5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff978720de6b56e295b274b126ecfc9f07689f7b39b72358e76abeb02196bf9d"
    sha256 cellar: :any_skip_relocation, ventura:        "affec39a5174a4333fd6bb2c7f6ce36fb817c7032faa565ddc3ef505ef7512a4"
    sha256 cellar: :any_skip_relocation, monterey:       "f8b66288fb9f60a09f0f284d64c7a4019eb0e66940a879101d5e20abc878540e"
    sha256 cellar: :any_skip_relocation, big_sur:        "84465d0a9bcc2ce550d35e359b490f98c2ae345076db1c0b28f8fce85c60ce9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6f36520350fa0d608c6ea74fb2949e62b9d3503e5dbbb923459d264a3e722e9"
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
