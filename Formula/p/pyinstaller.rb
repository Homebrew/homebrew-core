class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/63/41/f90302845945abd4ed647933ff5ee7c6ac93983187be67f897b6cb613331/pyinstaller-6.22.3.tar.gz"
  sha256 "05eb2f5615503e72939a7224d68b4aff572c6b0438ee4a17d0a4b481f399362d"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18541ae560dcc2220fd922dd6e14ea7836819dd7db5ceeea7a38f7032c368c12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4473d6b79784f52909926760284c7498180ca92817cf6bbf94b5995b441fd5d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f72ac247b5ad8a4aad46797c0c72d15176232655adaa2f1086ab0f9fd8164587"
    sha256 cellar: :any,                 arm64_linux:       "109928952235642d218e3d5fc3304dc320997add92196b6e3a2d937e1a1aab83"
    sha256 cellar: :any,                 x86_64_linux:      "82d2e50d994d46f223d1e4956049ae6981b42f3db6e9709281d10a3cc71aef17"
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
    url "https://files.pythonhosted.org/packages/c9/3b/fab1a12a21bf9223af012e5dd002b7d4265683d21d9fabbd0ccb347316e4/pyinstaller_hooks_contrib-2026.8.tar.gz"
    sha256 "4d825786ad7a9b7dbcc52d612748a34562fe273461bcfd88f4d549c594bbf8f9"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
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
