class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/94/94/1f62e95e4a28b64cfbb5b922ef3046f968b47170d37a1e1a029f56ac9cb4/pyinstaller-6.16.0.tar.gz"
  sha256 "53559fe1e041a234f2b4dcc3288ea8bdd57f7cad8a6644e422c27bb407f3edef"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc10b01609a928c23f3b44059c7084c8ae2206e49514c4219d6a9500698cb0db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "473e6c10eb021090c32fd031dce1473e9a0847523c2eb5c6a2cb7ff08a3000c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8b1b597fcb354e4ffce092b91457adaff8a6775c52852b87dbf6639e7a4247c"
    sha256 cellar: :any_skip_relocation, sonoma:        "68894b05bf5b8ca0934d8300d3ed75f0fc93e5de0be425caf048d117faa16f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1010bf24a461d198a984f668a6d4a5a663c5f5538130ec22edb336f6c87e21df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87db990b0f53f2b143d829272b420dc6c462c20d6451b495ecd443358a9567bf"
  end

  depends_on "python@3.14"

  uses_from_macos "zlib"

  pypi_packages exclude_packages: "macholib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/7d/83/be0f57c0b77b66c33c2283ebd4ea341022b5a743e97c5fb3bebab82b38b9/pyinstaller_hooks_contrib-2025.9.tar.gz"
    sha256 "56e972bdaad4e9af767ed47d132362d162112260cbe488c9da7fee01f228a5a6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    cd "bootloader" do
      system "python3.14", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~PYTHON
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    PYTHON
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_path_exists testpath/"dist/easy_install"
  end
end
