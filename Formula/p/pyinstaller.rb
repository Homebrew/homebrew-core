class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/9f/b8/0fe3359920b0a4e7008e0e93ff383003763e3eee3eb31a07c52868722960/pyinstaller-6.18.0.tar.gz"
  sha256 "cdc507542783511cad4856fce582fdc37e9f29665ca596889c663c83ec8c6ec9"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b375316c33a81ac23fda3afe6944da1bad689ef84915d46632ccdbeb6e35463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7200e300618bd30c1f992758ebaf1cead2c372bf1657e1c23fe8cd33fe708b9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab1c5d2f8ac54c725285360c6fec5303da629fa1cc9d56c1c83dcfeae3db3f50"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6251455bed9f966694695e4b9b28d2aca905df52f810ce142c167bf5e6fee21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "099feb873aff6d075fe4938399b16a9f7f178b70501ae738a1c3b9f925eaadc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "026f5f7bb47ee5e347298052afd977320415b7281c3a9886c825cf8b3371bac2"
  end

  depends_on "python@3.14"

  uses_from_macos "zlib"

  pypi_packages extra_packages: "macholib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/7e/f8/97fdf103f38fed6792a1601dbc16cc8aac56e7459a9fff08c812d8ae177a/altgraph-0.17.5.tar.gz"
    sha256 "c87b395dd12fabde9c99573a9749d67da8d29ef9de0125c7f536699b4a9bc9e7"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/10/2f/97589876ea967487978071c9042518d28b958d87b17dceb7cdc1d881f963/macholib-1.16.4.tar.gz"
    sha256 "f408c93ab2e995cd2c46e34fe328b130404be143469e41bc366c807448979362"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/45/2f/2c68b6722d233dae3e5243751aafc932940b836919cfaca22dd0c60d417c/pyinstaller_hooks_contrib-2025.11.tar.gz"
    sha256 "dfe18632e06655fa88d218e0d768fd753e1886465c12a6d4bce04f1aaeec917d"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    cd "bootloader" do
      system "python3.14", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    without = ["macholib"] unless OS.mac?
    virtualenv_install_with_resources(without:)
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
