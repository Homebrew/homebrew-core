class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://www.pyinstaller.org"
  url "https://files.pythonhosted.org/packages/b6/27/a006fcadba0db30819c968eb8decb4937cda398ca7a44d8874172cdc228a/pyinstaller-4.3.tar.gz"
  sha256 "5ecf8bbc230d7298a796e52bb745b95eee12878d141f1645612c99246ecd23f2"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75711c89dfaca5a231e9532dad47a1f16b3b64f27ea191da2db806a777a19bc4"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb1d6148599f36a8f35132c182dc2062af62bd3c3792b562d06ac3a1e9092db9"
    sha256 cellar: :any_skip_relocation, catalina:      "6dc9e1630ec207b522f3ff7339ed941f4463ccc6cd67e2a69ef4922b3ff6c1e5"
    sha256 cellar: :any_skip_relocation, mojave:        "194caf5c538bf6116de70b5cd80dd1ffa0ed82c4c1f6e0c92cd40154e65bf7ad"
  end

  depends_on "python@3.9"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/22/5a/ac50b52581bbf0d8f6fd50ad77d20faac19a2263b43c60e7f3af8d1ec880/altgraph-0.17.tar.gz"
    sha256 "1f05a47122542f97028caf78775a095fbe6a2699b5089de8477eb583167d69aa"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/0d/fe/61e8f6b569c8273a8f2dd73921738239e03a2acbfc55be09f8793261f269/macholib-1.14.tar.gz"
    sha256 "0c436bc847e7b1d9bda0560351bf76d7caf930fb585a828d13608839ef42c432"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/70/4b/453588ea48782e7c3e531d2fc016aa88248687123bfac9d5c72f57a4def6/pyinstaller-hooks-contrib-2021.1.tar.gz"
    sha256 "892310e6363655838485ee748bf1c5e5cade7963686d9af8650ee218a3e0b031"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    xy = Language::Python.major_minor_version "python3.9"
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              libexec/"lib/python#{xy}/site-packages/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
