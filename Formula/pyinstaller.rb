class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/4c/22/2f7a5308dcbf8baad514bfd8a7d453f133cf35b52055ab1668ced59e3ac5/pyinstaller-5.4.tar.gz"
  sha256 "dabacb2a1f87d9f669fe726b0e46b1de63a3c0948aad1caced0670de39b986d1"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "345c637d5323f32fd2102100c5508f385d04697497ef7ac2ff3cd35d726fcce2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9711623ddbdf0424c570a607c8acd4f3148cb0b629d51c2e18f701f4b39c32e0"
    sha256 cellar: :any_skip_relocation, monterey:       "705d7acaada8206858f53833d60ec8e78b0afe656354c92c60e4a32cb4932aa1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0dae83fe88adae39f8ec82ccebdf7259fb9f116af856f8b2a2c7b82fde8366c"
    sha256 cellar: :any_skip_relocation, catalina:       "75d9520d7318f37fdaac1f562f7dd0f2b632bf0ee6f07065e7e3ed70ff5dfb76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b80e59bc7800feac8b113153143c1a88bc2de00a024efe98635eda6d6ce81c9f"
  end

  depends_on "python@3.10"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/a9/f1/62830c4915178dbc6948687916603f1cd37c2c299634e4a8ee0efc9977e7/altgraph-0.17.2.tar.gz"
    sha256 "ebf2269361b47d97b3b88e696439f6e4cbc607c17c51feb1754f90fb79839158"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/16/1b/85fd523a1d5507e9a5b63e25365e0a26410d5b6ee89082426e6ffff30792/macholib-1.16.tar.gz"
    sha256 "001bf281279b986a66d7821790d734e61150d52f40c080899df8fefae056e9f7"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/8d/46/5b21e3eedc41fe0a8522e409ab2c71ebf137eab0f9e632c5213e76f97b7e/pyinstaller-hooks-contrib-2022.10.tar.gz"
    sha256 "e5edd4094175e78c178ef987b61be19efff6caa23d266ade456fc753e847f62e"
  end

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
