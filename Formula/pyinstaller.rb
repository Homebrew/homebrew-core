class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/87/0b/0b9cfa5ed2ffcb9f3ae4335c436e4e250a5ea4c4d7dac4a693ed7f2b14dd/pyinstaller-5.9.0.tar.gz"
  sha256 "2bde16a8d664e8eba9aa7b84f729f7ab005c1793be4fe1986b3c9cad6c486622"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4212ac151e747103c691c06c4c2be3f9d14fd38cf410e2e11669c3958d0716f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d64f61e05d47eb50068c04feec96a44f040514ff0a6b5c6d4077aa27906b5979"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9542ae2b148e0d3f3c2adc71baa6dbc22c4c541f10e8bc168e587b7bda2f6f8c"
    sha256 cellar: :any_skip_relocation, ventura:        "54db81f16f026469ca2a967500ccf4e14456400a50ae094b9c7c78486211646a"
    sha256 cellar: :any_skip_relocation, monterey:       "e9c9b77a5a38be6276e880a29fd023a95db6ddb2d8d6628ad10cd2ac8aa1b0e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0efce3357fb6854d3e7d43cfee8b85bfb540beda4c425b7e12c22896c8247a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d43b860a51e133d3d41dee4c7d54de6c31c891ab0cdbf17b6acd808def2d97b5"
  end

  depends_on "python@3.11"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/5a/13/a7cfa43856a7b8e4894848ec8f71cd9e1ac461e51802391a3e2101c60ed6/altgraph-0.17.3.tar.gz"
    sha256 "ad33358114df7c9416cdb8fa1eaa5852166c505118717021c6a8c7c7abbd03dd"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/46/92/bffe4576b383f20995ffb15edccf1c97d2e39f9a8c72136836407f099277/macholib-1.16.2.tar.gz"
    sha256 "557bbfa1bb255c20e9abafe7ed6cd8046b48d9525db2f9b77d3122a63a2a8bf8"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/6b/74/1d010b2f86db7dd4622a52a69f53c7cdfe60564def3cfcfb9fb1f141406d/pyinstaller-hooks-contrib-2023.0.tar.gz"
    sha256 "bd578781cd6a33ef713584bf3726f7cd60a3e656ec08a6cc7971e39990808cc0"
  end

  def install
    cd "bootloader" do
      system "python3.11", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
