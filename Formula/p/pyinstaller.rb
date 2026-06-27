class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/d5/4d/ec706c3fcf39e26888c35b39615ff4d5865d184069666c47492cff1fbe50/pyinstaller-6.21.0.tar.gz"
  sha256 "bb9fab705983e393a2d1cac77d6972513057ad800215fd861dc15ff5272e98fd"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da3c4081f26d74c3b3b9a1a6050324bbbecfa65ecd2ab080b2215c12e1ff65a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffcfcb1e60af40ff315f2ac4b23cc4da2b594cb2540032e851caa4e145c9a407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e7bf1936ab5258363d844bf46302dd0c7f1b5d388043d4865d180cca55489be"
    sha256 cellar: :any_skip_relocation, tahoe:         "a288f3b4cc40729d3af05ab5837f433b1bcd9cc428053b9655e619d432164cfa"
    sha256 cellar: :any_skip_relocation, sequoia:       "e25d1a82b8ec496c0caeb336cb5e679a1aec4fef826991df0ba5662c626a55d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9350e81f28858c475be8d502afa8212041137733ce657c3dfcf4ce280d84d439"
    sha256 cellar: :any,                 arm64_linux:   "5c92eb4b73ecb4367a13e92e077fbcaa644d2be676d2569715da0d5500c59dd3"
    sha256 cellar: :any,                 x86_64_linux:  "4359ea7c62a43c94f182de3bbe9e2d67dacd835c6038d5d632b2e44dc3f7280f"
  end

  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/94/5b/c9fe0db5e83ee1c39b2258fa21d23b15e1a60786b6c5990ee5074ead8bb6/pyinstaller_hooks_contrib-2026.6.tar.gz"
    sha256 "bef5002c32f4f50bd55b005da12cff64eca8783e7eaf86a06a62410164bab725"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
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
