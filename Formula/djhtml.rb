class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/08/f1/e94061a6022709b946df5aea146bac328b1f8b32c4ab0a43f96a7c26a271/djhtml-1.5.1.tar.gz"
  sha256 "d3b9060e9c45e2a56125203f2508ae591aba41a2f14ed2fa8bafb99b0fc15eb3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c716ae3f7e31dd6fd478b9cd128892c04fd58330f1f02ffaee6208015a9dc5a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db8591b1d3b05551a30cdc8409019395f90af4c92f7eba627d88081cf7a4d311"
    sha256 cellar: :any_skip_relocation, monterey:       "727a8e1272e93ab3c433ca7f7a6bd2780383d7fb885a212faeb559b9824c679d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fda302276d2701c8c5439fb36583c597a99492f111ff747735f36d069fc8151e"
    sha256 cellar: :any_skip_relocation, catalina:       "54b7dc6ca0517fef397e7302191f4aa7ac4cb5f871315ca9a1daf8deb4398303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c93f336938e2a2deb9ec4f90204b257c9e82b488e5994dbb942418b20ab213d"
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
