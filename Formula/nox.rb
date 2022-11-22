class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/bb/1b/d5c87d105189bf4e3811f135c8a20c74ae9f81a34d33a1d0d1cd81383dd5/nox-2022.11.21.tar.gz"
  sha256 "e21c31de0711d1274ca585a2c5fde36b1aa962005ba8e9322bf5eeed16dcd684"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1facabdfdea0ba120d1a44de8c7409f63ab7bb338f09dccc71703c0cc44c04e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53829f76bcdf70be0e599db535b8a3dabe1c8371f0cd8a07db5e071d30614da4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3cd7b3bf8de23c799b550706cad9a27a7a81b6c9f1a613f83f0a8f51c946409"
    sha256 cellar: :any_skip_relocation, ventura:        "b39f2b7b3e36dd620bcfe048b895c2aa2bc9f78b598187152c872955069e26e3"
    sha256 cellar: :any_skip_relocation, monterey:       "c3f604c923c78043a8f4529dee9ec017e8ef8d936a900aabcee39a92d2314c21"
    sha256 cellar: :any_skip_relocation, big_sur:        "e933219424cf14822e98bda316f73e2bbe89d213d8e91966a05429e92c42ef92"
    sha256 cellar: :any_skip_relocation, catalina:       "98ce85b4cdd6a3860ca25626d9f3e95a31ef36a79fb1d7171d647d64927d578a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a995b2f9c21012e207ec1f5c8b7394c7e40cd5403dde2cb98ca3c2d60e43faa5"
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
