class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/fb/f8/a0bfbf01945821c5d9887ecef8ee6a25c1373339ab75ddc3e7a8dbc99ce3/pyinstaller-5.12.0.tar.gz"
  sha256 "a1c2667120730604c3ad1e0739a45bb72ca4a502a91e2f5c5b220fbfbb05f0d4"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14f7867148c63ed48c7f7aa7219a6d306e63af008a054da4b760f9260febf885"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f65cd177964e19c2a83565384e9209103792aedbd97066724c02f06cb38cdd68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec284c82befba0dd4d0d06648206a64f077968abe55a4ea7f5f355a27bb44419"
    sha256 cellar: :any_skip_relocation, ventura:        "3fc694a92def8e24b4429f910a1324cf78e7f7c97cb0e67ed117247da546574f"
    sha256 cellar: :any_skip_relocation, monterey:       "0f148daff649bef4ea7293462f4bd10b89cfe52597ce74d8550cdf3effa6c829"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5a40f2a00212e87d93fb7c12667c1e5aea163e56319a60779507353950cfa0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f76dcb5858ed8853a17531b490414643c522d5a7d4c3eca28f67aa75cac04c34"
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
    url "https://files.pythonhosted.org/packages/2b/12/4a8ccd4d5b9aa317854f5070ba0df2e269b6ceb30efd7acf13dd887d4c0b/pyinstaller-hooks-contrib-2023.3.tar.gz"
    sha256 "bb39e1038e3e0972420455e0b39cd9dce73f3d80acaf4bf2b3615fea766ff370"
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
