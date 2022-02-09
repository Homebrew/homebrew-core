class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/89/9d/dfcf0ff768ccad182719e0d218b067f98ae23a7ce5bfeb272dc0915b2a7f/djhtml-1.4.14.tar.gz"
  sha256 "04de986f913a4c474c12fcadd9868f415fd92136bf5e2fbd0ab004be5839bbd5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1a41b935d1de5261e14e8e18bcb5585111bc897baa3b170fc7501dff6810832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7319a2c5864be8d3b5c2cf106507206d8ee2d856361e8d17925436a651d8e34d"
    sha256 cellar: :any_skip_relocation, monterey:       "45505bea25ce5b1bae0793c5e50d832588fd1c3615c6669fe3f9da884632fa03"
    sha256 cellar: :any_skip_relocation, big_sur:        "eef0bf283afb4e3c68b4d88ba402e2b695cb7d377b61b7131744e4f9841ce004"
    sha256 cellar: :any_skip_relocation, catalina:       "dbc50ee9db05d985ef7b6259db13452bbfc7ee98255fdac0b6b0330d683cd413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76215a1c81615c3a721cf93f63c07ac27f8af343e8118a08f650fb011a8dc992"
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
