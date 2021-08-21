class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://www.pyinstaller.org"
  url "https://files.pythonhosted.org/packages/a9/d9/9fdfb0ac2354d059e466d562689dbe53a23c4062019da2057f0eaed635e0/pyinstaller-4.5.1.tar.gz"
  sha256 "30733baaf8971902286a0ddf77e5499ac5f7bf8e7c39163e83d4f8c696ef265e"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f62cafb5efa21e3134de45dfff0fb8d3c2ed6f715d3ae9df4486e0aee791193"
    sha256 cellar: :any_skip_relocation, big_sur:       "03823e8b8f5ca5abc9415cd09711b3e8bc89f517d99921c25a04a2c521e890a3"
    sha256 cellar: :any_skip_relocation, catalina:      "c318c0284d2222ec06f90cbd33202a923e530edb3d7577c64b58f72d9ffb1b95"
    sha256 cellar: :any_skip_relocation, mojave:        "71cabd305a504f8fbdd6ef48ab4f5583bfb17cc7980b835bb7dc293e6a328103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a70f2e6a43c9257ca7f705ef9ee794b0df61983f5e92a6739337b074930442d"
  end

  depends_on "python@3.9"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/22/5a/ac50b52581bbf0d8f6fd50ad77d20faac19a2263b43c60e7f3af8d1ec880/altgraph-0.17.tar.gz"
    sha256 "1f05a47122542f97028caf78775a095fbe6a2699b5089de8477eb583167d69aa"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/5f/cd/045e6e025d7484eef8c534a0ffe98792fd1ea19aadc8ac048a5ed9272e9d/macholib-1.15.tar.gz"
    sha256 "196b62c592e46f0859508a73a11eca6b082a5c8db330ba90cb56f2409e48e2d5"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/eb/fa/fe062e44776ab8edb4ac62daca1a02bb744ebdd556ec7a75c19c717e80b4/pyinstaller-hooks-contrib-2021.2.tar.gz"
    sha256 "7f5d0689b30da3092149fc536a835a94045ac8c9f0e6dfb23ac171890f5ea8f2"
  end

  # Work around to create native thin bootloader using `--no-universal2` flag
  # Upstream ref: https://github.com/pyinstaller/pyinstaller/issues/6091
  patch :DATA

  def install
    cd "bootloader" do
      system "python3", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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

__END__
--- a/bootloader/wscript
+++ b/bootloader/wscript
@@ -360,7 +360,7 @@ def set_arch_flags(ctx):
             if ctx.options.macos_universal2:
                 mac_arch = UNIVERSAL2_FLAGS
             else:
-                mac_arch = ['-arch', 'x86_64']
+                mac_arch = []
         ctx.env.append_value('CFLAGS', mac_arch)
         ctx.env.append_value('CXXFLAGS', mac_arch)
         ctx.env.append_value('LINKFLAGS', mac_arch)
