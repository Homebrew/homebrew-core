class Ly < Formula
  include Language::Python::Virtualenv

  desc "Parse, manipulate or create documents in LilyPond format"
  homepage "https://github.com/frescobaldi/python-ly"
  url "https://files.pythonhosted.org/packages/9b/ed/e277509bb9f9376efe391f2f5a27da9840366d12a62bef30f44e5a24e0d9/python-ly-0.9.7.tar.gz"
  sha256 "d4d2b68eb0ef8073200154247cc9bd91ed7fb2671ac966ef3d2853281c15d7a8"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "038b39a72ba2a8eb2a1ac853e8c7e26228c3dfc97e4d639bd0b9a19507bdb11a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "038b39a72ba2a8eb2a1ac853e8c7e26228c3dfc97e4d639bd0b9a19507bdb11a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "038b39a72ba2a8eb2a1ac853e8c7e26228c3dfc97e4d639bd0b9a19507bdb11a"
    sha256 cellar: :any_skip_relocation, ventura:        "83799e7be92015501c6b041cc121a9ffff202b46d995e618b5bf131dc571bd5b"
    sha256 cellar: :any_skip_relocation, monterey:       "83799e7be92015501c6b041cc121a9ffff202b46d995e618b5bf131dc571bd5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "83799e7be92015501c6b041cc121a9ffff202b46d995e618b5bf131dc571bd5b"
    sha256 cellar: :any_skip_relocation, catalina:       "83799e7be92015501c6b041cc121a9ffff202b46d995e618b5bf131dc571bd5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dd0337b0b409bba2cc68d2639d74de072eba648a12dfd212f4813b479dd0ddb"
  end

  depends_on "python@3.11"

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
        .opt_libexec/"bin/python"
  end

  def install
    virtualenv_install_with_resources

    site_packages = prefix/Language::Python.site_packages(python3)
    python_version = Language::Python.major_minor_version(python3)
    site_packages.install_symlink libexec/"lib/python#{python_version}/site-packages/ly"
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    output = shell_output "#{bin}/ly 'transpose c d' #{testpath}/test.ly"
    assert_equal "\\relative { d' e fis g a b cis d }", output

    system python3, "-c", "import ly"
  end
end
