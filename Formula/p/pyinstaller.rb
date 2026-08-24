class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/cc/2b/836d9def811c02522e0921d8b8cdf0c16b0545a216e97e71041758057859/pyinstaller-6.22.2.tar.gz"
  sha256 "89b65a3ad07d9dd5832253e37bc45f31872d10d7f9d5c9fd0fdd6088a83829dd"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "305ab3f270881769096ec82fa71d1d80bc80ef8c7894f1e958852f7c4bbe1238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b86a3cf26e8a1c9cd37aa206a96d9a419021ef76de3fa3ee8045d7fd5050286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f3b1afacf067554db230ce01ede693275db1365f3c86f8b13df5452386ae82"
    sha256 cellar: :any_skip_relocation, tahoe:         "8a418fb9d32e8e5a04409087c928c434f802b69cc4a5d2e2aa6a65de8840ac4b"
    sha256 cellar: :any_skip_relocation, sequoia:       "f006f5b002bd964e595927074134db9ab5a69336884187f3b78c4831367b5384"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e26b9fdfbd92b66d88eaf1d35e6fec6606c1a364838699a734f6975c2e9b044"
    sha256 cellar: :any,                 arm64_linux:   "84231b49c33542e16f0fc650e7e56e0101f92b65d97e2e7527bb944e4815b64b"
    sha256 cellar: :any,                 x86_64_linux:  "b72336867aa0cda5311b29bba3b1263283d58e27f72402690431bb1893da451b"
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
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/94/5b/c9fe0db5e83ee1c39b2258fa21d23b15e1a60786b6c5990ee5074ead8bb6/pyinstaller_hooks_contrib-2026.6.tar.gz"
    sha256 "bef5002c32f4f50bd55b005da12cff64eca8783e7eaf86a06a62410164bab725"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
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
