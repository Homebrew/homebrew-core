class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/26/8f/b838a00b9fa0033c210e5fddb43d41ac3f500decf840e6b251ea18c3da6e/djhtml-1.5.2.tar.gz"
  sha256 "b54c4ab6effaf3dbe87d616ba30304f1dba22f07127a563df4130a71acc290ea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b76125bdfb4cd9cbe68a56d6d1d6551e63b02bbbb9c39bffeba12dcbabca9b44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2f13b84ccb83d160f351e61d459e37b89399dd8a91877fb3c72d4982e723919"
    sha256 cellar: :any_skip_relocation, monterey:       "f4a6359f07e55c49e28409766cf0bb0aa20aaa41e2b3580d8920091eaf9b014a"
    sha256 cellar: :any_skip_relocation, big_sur:        "948cda3ae2bf94c34156b0ca67824451e79bd58f81f162cc4195bf7df50bd7b2"
    sha256 cellar: :any_skip_relocation, catalina:       "020a501a1ed2f3c3a4fef6d155620f4a54bb702bbe9c3f792b057ba97df77baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21ca66140574f8b56d5bc2672f7f9a88ea3165c092c2beff6fb6ea83b8fc3377"
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
