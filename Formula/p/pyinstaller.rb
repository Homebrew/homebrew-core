class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/c8/63/fd62472b6371d89dc138d40c36d87a50dc2de18a035803bbdc376b4ffac4/pyinstaller-6.19.0.tar.gz"
  sha256 "ec73aeb8bd9b7f2f1240d328a4542e90b3c6e6fbc106014778431c616592a865"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44a696fd78cacec38fa8fecaea843f65bdb3e03c3ddfaaefcc0c0cd0c72ab872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd2f2dfd000c56a1db5c39b5aadf7bc554aab42d93036d23835ef4639eb6de80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda92fa93b71941c60448a24c28a0f10b4c39ee041f3345aa503c43776870f20"
    sha256 cellar: :any_skip_relocation, tahoe:         "cf54dbf3b85768d852b5ab5a8c5bce0a33117b757fa7a59fa9233e4356fcd834"
    sha256 cellar: :any_skip_relocation, sequoia:       "28c1b664cb04e1ee950e720c89a5fcad78f99047ef30f5d0ceb8b04455c07b92"
    sha256 cellar: :any_skip_relocation, sonoma:        "4249f190ff12fa683732b5cf8cfc371a1c9eb1f5600b9a8359df9b7af35eb6f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da47ef2ff3cf07b031384bbc51ae8dad8267bea9674afea3905e1f721bac71dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce89a7bde964bd597e0bd93fc18bc39f4659f813c711ffd329f0a4999618c18e"
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
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/31/8f/8052ff65067697ee80fde45b9731842e160751c41ac5690ba232c22030e8/pyinstaller_hooks_contrib-2026.0.tar.gz"
    sha256 "0120893de491a000845470ca9c0b39284731ac6bace26f6849dea9627aaed48e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/82/f3/748f4d6f65d1756b9ae577f329c951cda23fb900e4de9f70900ced962085/setuptools-82.0.0.tar.gz"
    sha256 "22e0a2d69474c6ae4feb01951cb69d515ed23728cf96d05513d36e42b62b37cb"
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
