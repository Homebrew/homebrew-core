class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/bb/1b/d5c87d105189bf4e3811f135c8a20c74ae9f81a34d33a1d0d1cd81383dd5/nox-2022.11.21.tar.gz"
  sha256 "e21c31de0711d1274ca585a2c5fde36b1aa962005ba8e9322bf5eeed16dcd684"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f0f23c7102f0aa1c3253ff48bf7b3cad48995cf8179c2ea8c2d7ccdc2b69fe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c50a6446b385e6918e50f722e7b4fbda7f3367cd7de5b3b225f0dc743648e91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "202346d07ff46eb88d0db0607168e43b978606255fe7ac29383504b3be9b389e"
    sha256 cellar: :any_skip_relocation, ventura:        "75f8cda188f16e991a41547021a68424b8c5a76a159ce5011dd3801e3bfaff60"
    sha256 cellar: :any_skip_relocation, monterey:       "cf8c1e4cef9105a72680fa84ba6899e07ea8739921d15c65a55a5c6c7c994ced"
    sha256 cellar: :any_skip_relocation, big_sur:        "76c96bfaaba66c385002caf4e9b18581c1876c928652733ffc87c5c61baeda81"
    sha256 cellar: :any_skip_relocation, catalina:       "f7215557be4811a34b35042f7f6ba5f0eecb5d3e8e0160e7a55ccc535252721a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96ea5be4ebdaff105fc68e902a912f199b6fe2383b2cc9969ee49b35f7f0589e"
  end

  depends_on "python@3.11"
  depends_on "six"
  depends_on "virtualenv"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~EOS
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "1 passed", shell_output("#{bin}/nox")
  end
end
