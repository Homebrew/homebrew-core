class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/59/b3/ab2546e09f21dff93205dfad01903718ac436d134de42ff8e76c846a60f1/djhtml-1.5.0.tar.gz"
  sha256 "eeccc5e5cc6d1371e8434903de5043b24efa1000b6857b9bf342e1868aa995ae"
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
