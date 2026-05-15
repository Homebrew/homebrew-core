class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/46/60/d03d52e6690d4e9caf333dcd14550cde634ce6c118b3bc8fa3112c3186fd/pyinstaller-6.20.0.tar.gz"
  sha256 "95c5c7e03d5d61e9dfb8ef259c699cf492bb1041beb6dbe83696608cec07347a"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e7bde3effe6d5704f85e126f31b1f97cfdbc77193d49f80c1e349eb440e0c1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf1cc164c94bf9fea352935c87ceea78cbd7741b40dd309055eaac31d6c1a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9098d66121dd0399504f4d1b4c71cee6048cb5bc1c07dbb754c9a77ef1be80f3"
    sha256 cellar: :any_skip_relocation, tahoe:         "74d0bf37ef712691a6ad502ad773c8a9c9926b036c1c91fc0a54d5bb60507561"
    sha256 cellar: :any_skip_relocation, sequoia:       "cc65d81b8970ec9e0e383410266a3a1cfc9d61c6e0060d8f0f8ec8e98b2bacac"
    sha256 cellar: :any_skip_relocation, sonoma:        "68685e7133a973aecfa42ac084ff6e9d0012765c87eb49473416e078f2838f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d77020b961151ac0ed3e8eb32c9634ca1e4065e2c0211326e5c45be0cd7a254f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11a70ececf86df4d0430126c3b291368ed3cfd6af4983cfdd5a9b631ff00fcec"
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
    url "https://files.pythonhosted.org/packages/df/de/0d2b39fb4af88a0258f3bac87dfcbb48e73fbdea4a2ed0e2213f9a4c2f9a/packaging-26.1.tar.gz"
    sha256 "f042152b681c4bfac5cae2742a55e103d27ab2ec0f3d88037136b6bfe7c9c5de"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/c7/fe/9278c29394bf69169febc21f96b4252c3ee7c8ec22c2fc545004bed47e71/pyinstaller_hooks_contrib-2026.4.tar.gz"
    sha256 "766c281acb1ecc32e21c8c667056d7ebf5da0aabd5e30c219f9c2a283620eeaa"
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
