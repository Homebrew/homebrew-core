class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://www.pyinstaller.org"
  url "https://files.pythonhosted.org/packages/b4/83/9f6ff034650abe9778c9a4f86bcead63f89a62acf02b1b47fc2bfc6bf8dd/pyinstaller-4.2.tar.gz"
  sha256 "f5c0eeb2aa663cce9a5404292c0195011fa500a6501c873a466b2e8cad3c950c"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "eb1d6148599f36a8f35132c182dc2062af62bd3c3792b562d06ac3a1e9092db9" => :big_sur
    sha256 "75711c89dfaca5a231e9532dad47a1f16b3b64f27ea191da2db806a777a19bc4" => :arm64_big_sur
    sha256 "6dc9e1630ec207b522f3ff7339ed941f4463ccc6cd67e2a69ef4922b3ff6c1e5" => :catalina
    sha256 "194caf5c538bf6116de70b5cd80dd1ffa0ed82c4c1f6e0c92cd40154e65bf7ad" => :mojave
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
    url "https://files.pythonhosted.org/packages/ad/ac/25bd5c6f192280182403e75e62abc5f8113cf3f287c828987ce62fd4b07f/pyinstaller-hooks-contrib-2020.11.tar.gz"
    sha256 "fc3290a2ca337d1d58c579c223201360bfe74caed6454eaf5a2550b77dbda45c"
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
