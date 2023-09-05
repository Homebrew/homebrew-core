class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/bd/23/c5f0163b2049699cdbb511eac72798f017d4c9a3f4ba571fbef398156e3d/pyinstaller-5.13.2.tar.gz"
  sha256 "c8e5d3489c3a7cc5f8401c2d1f48a70e588f9967e391c3b06ddac1f685f8d5d2"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de96baae129192693a1e195cd6cf768f70c8fc1277c08203f6a644974f6008e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "778931f20c3a946f6b4d3ccd8ea05db0a782f820912f766258dc2e582f60db10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72ad1f15a5707af9ac75bbecfc7b1b89355c0c3d9e350a2a88f7252374202fe1"
    sha256 cellar: :any_skip_relocation, ventura:        "cc4fa1ad1c20e303350aee514adde4a12240459001d01ae657fdf7b33976c1b3"
    sha256 cellar: :any_skip_relocation, monterey:       "31dd69d61be3e13fd506beb31c94537af5c62991a8144eaed7b7d78fbbb39a53"
    sha256 cellar: :any_skip_relocation, big_sur:        "02ae7b5cffd7523887ec01ea9ba5adddb7fc793fe2d2aace03547d826fbe3dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b580361f0650fdb9b79c52f8d06dd48c3531bdfdfe90523abc9222abdb7638e"
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
    url "https://files.pythonhosted.org/packages/ba/0b/0c0557ec47e3159881df337efca70d79d193fae4af43deba196254b668d8/pyinstaller-hooks-contrib-2023.8.tar.gz"
    sha256 "318ccc316fb2b8c0bbdff2456b444bf1ce0e94cb3948a0f4dd48f6fc33d41c01"
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
