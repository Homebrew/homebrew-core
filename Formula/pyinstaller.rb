class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://www.pyinstaller.org"
  url "https://files.pythonhosted.org/packages/82/96/21ba3619647bac2b34b4996b2dbbea8e74a703767ce24192899d9153c058/pyinstaller-4.0.tar.gz"
  sha256 "970beb07115761d5e4ec317c1351b712fd90ae7f23994db914c633281f99bab0"
  license "GPL-2.0"

  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5b5c872f6ed44dee85485f97743f066aaba0de5a7ef5a1817330ae9ac3ae502" => :catalina
    sha256 "d169b298d3b87b48d0e53591deb6b794128705850a7b9a064786ea323953dda4" => :mojave
    sha256 "5ab59b261f6a112da5e0423e7fb08912d421ab2c0ff27f4f477f262e8c55a0f0" => :high_sierra
  end

  depends_on "python@3.8"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/22/5a/ac50b52581bbf0d8f6fd50ad77d20faac19a2263b43c60e7f3af8d1ec880/altgraph-0.17.tar.gz"
    sha256 "1f05a47122542f97028caf78775a095fbe6a2699b5089de8477eb583167d69aa"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/0d/fe/61e8f6b569c8273a8f2dd73921738239e03a2acbfc55be09f8793261f269/macholib-1.14.tar.gz"
    sha256 "0c436bc847e7b1d9bda0560351bf76d7caf930fb585a828d13608839ef42c432"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/43/75/0b6c3736535f2aa36d86aff693a85fb72af48a93253ee464b4c975f5b6de/pyinstaller-hooks-contrib-2020.7.tar.gz"
    sha256 "74936d044f319cd7a9dca322b46a818fcb6e2af1c67af62e8a6a3121eb2863d2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    xy = Language::Python.major_minor_version "python3.8"
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              libexec/"lib/python#{xy}/site-packages/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
