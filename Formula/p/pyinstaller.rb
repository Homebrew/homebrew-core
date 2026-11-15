class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/63/41/f90302845945abd4ed647933ff5ee7c6ac93983187be67f897b6cb613331/pyinstaller-6.22.3.tar.gz"
  sha256 "05eb2f5615503e72939a7224d68b4aff572c6b0438ee4a17d0a4b481f399362d"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "778cf65f9f6d9914c254d0a8ed921f574a3e4e4d588b16dc0e8a77fae9cb853c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a627e7d9a2512d36d045e0316905c25c8fccd116e8aebfdb64a4ec2e0318ed2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf2e5ba2bd4c14ef54ef6563113238f8156580afc057ea1bcf2948fc5b52a4e6"
    sha256 cellar: :any,                 arm64_linux:       "ca8f013836cb4cdefd248f35f17fa6e6eb36f2840d12deb1579b65358c6aee30"
    sha256 cellar: :any,                 x86_64_linux:      "11a4f4b1831a81d66d74b77cf1f672497130f1af29be54ce1e627daaa6226c08"
  end

  depends_on "python@3.15"

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
    url "https://files.pythonhosted.org/packages/96/25/e47c6188228281372be7e9911a93931e01ec8798c02c93abd680b9b9521f/pyinstaller_hooks_contrib-2026.9.tar.gz"
    sha256 "2748767901acb5cecd1304652b6c7add5bffcff1d71d01207fe24a5d42942a56"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  def install
    cd "bootloader" do
      system python3, "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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
