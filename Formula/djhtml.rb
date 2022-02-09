class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/89/9d/dfcf0ff768ccad182719e0d218b067f98ae23a7ce5bfeb272dc0915b2a7f/djhtml-1.4.14.tar.gz"
  sha256 "04de986f913a4c474c12fcadd9868f415fd92136bf5e2fbd0ab004be5839bbd5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7557bd3d5c930a86dddc9a55140ea9572c8724775d1d60f50e0fb28dfb8c00d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "651ec2b991d479823e98a5cebfeed12a7b7d3cd36f3d8f67cc0b049bda331751"
    sha256 cellar: :any_skip_relocation, monterey:       "40a6053416eb23dd787bc18c7055f43fb24dc1c32e11869b80b6789df16e3861"
    sha256 cellar: :any_skip_relocation, big_sur:        "b79a4000786588ce5f1b5a35bd1ea2816ebdc23165c8eced488d7506a526ea77"
    sha256 cellar: :any_skip_relocation, catalina:       "5a7da426915503ab9150483c1f6509f097f799f4a6e6062f0181e654c511f970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b1b538e419f50ab25797bb96617bf0edac36db6f4fd497d23b25dabbe65b91d"
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
