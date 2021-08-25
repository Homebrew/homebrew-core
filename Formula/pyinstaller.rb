class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://www.pyinstaller.org"
  url "https://files.pythonhosted.org/packages/a9/d9/9fdfb0ac2354d059e466d562689dbe53a23c4062019da2057f0eaed635e0/pyinstaller-4.5.1.tar.gz"
  sha256 "30733baaf8971902286a0ddf77e5499ac5f7bf8e7c39163e83d4f8c696ef265e"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4272eaf2d73796e1509b1df73cd8d16b94a6355b27abac02f0ce0d17741260f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "18d32eca7f24a755e73cdc63f64f1c2bbd813ee16d91d5f883a77cad112ea3a7"
    sha256 cellar: :any_skip_relocation, catalina:      "fcd5279e9d8fc01bdd988a3ad7ebb3bb13162f0221d1651746beb55570824c92"
    sha256 cellar: :any_skip_relocation, mojave:        "14b0ce068eb56e05a847cc72834163072ef3da7bfdbbd517d2f82255164ed226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd94131c0b3c6bc8938c00b9c0a9dd1e00a7718b3a92fde29babaf60c5f5e600"
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
