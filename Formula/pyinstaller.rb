class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/13/2e/bc4c0026659cea46aca867f4d71e8bab5a6430b4c005c51e174da5e6e4a2/pyinstaller-5.7.0.tar.gz"
  sha256 "0e5953937d35f0b37543cc6915dacaf3239bcbdf3fd3ecbb7866645468a16775"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f25e5cb2efbe1506c2973c851bfa93de48b8be1074419645bdecb907e1f9bca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da5e2a251590824f466a9bc21ea3b4b07aadf2fcf393e0e22b3b5b0334bfe602"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4f58a1a77383d4cf07d137854eeca8aaf5e699fe637d80b97455393dd65ac42"
    sha256 cellar: :any_skip_relocation, ventura:        "7952764b8061d4a5678fc6ecab4b8fbf3068626632cdc01683e7db8305c0ba65"
    sha256 cellar: :any_skip_relocation, monterey:       "a8870c99cde051fcb118e1e334bdc637723c6b21b8b41d235bacd817d278fd74"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8585c90f9d370e892a20ed815e1220146459d7ca3a75499cb971fbea4f9424a"
    sha256 cellar: :any_skip_relocation, catalina:       "b18dceb891755a4afea75d15a42b01b8ce02758090aba9ec0fb5e4cc995608da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db279ab85f62aa10a8f580a7baa38d372d0543a09640b5eca9d986f501d070bf"
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
    url "https://files.pythonhosted.org/packages/f4/e1/1b4f8394be02574479167b0f09a9fdb3ca4f184b45bd89d5878e44ba72ed/pyinstaller-hooks-contrib-2022.14.tar.gz"
    sha256 "5ae8da3a92cf20e37b3e00604d0c3468896e7d746e5c1449473597a724331b0b"
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
