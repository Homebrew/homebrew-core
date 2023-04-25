class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/51/37/2e0195ef4e4dec35e3f116361c4c780e0c4cd2cd96079199b3218c08fabb/pyinstaller-5.10.1.tar.gz"
  sha256 "6ecc464bf56919bf2d6bff275f38d85ff08ae747b8ead3a0c26cf85573b3c723"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6c9482629dbc9908f78fdc99330cd5f0fe6a13286924f4d605e898726fa5df4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "173d1ef4ee056bab253600cb09565696c3365abb49439a4e319a444a700068b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62a198839c9b71833ca3d808f08a28ec872c1e1852102c0fdd261dd4a3f8e6ae"
    sha256 cellar: :any_skip_relocation, ventura:        "521eaa8392c79de73b4f9442d78fab249923ebe6ebb8eae113a5e64078cef524"
    sha256 cellar: :any_skip_relocation, monterey:       "e0af1b56dfb13b6869f88835bc0b6f0493467c41e295dc58ad0dd6b402e83741"
    sha256 cellar: :any_skip_relocation, big_sur:        "614ec98a16175c6180ca5e0697b15e0b3bf07e1aae674b8cc5d7ab5875c69cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab3da4a6b5c32622d08e8d81a3def013a76d89ff45582aa437df245229a1080"
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
    url "https://files.pythonhosted.org/packages/67/22/2f49f4693bc7db9f2ee7a05a3c04f255b3db4251a0f1ff003b8ab9f87ff4/pyinstaller-hooks-contrib-2023.2.tar.gz"
    sha256 "7fb856a81fd06a717188a3175caa77e902035cc067b00b583c6409c62497b23f"
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
