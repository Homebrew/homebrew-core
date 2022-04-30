class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/ad/09/82d3f066eddb9ab3cbed8284a0bda84a93806ff2c44536474841a98ae0e7/pyinstaller-5.0.1.tar.gz"
  sha256 "25f5f758b005c66471af0d452c90ec328179116afe9d5bd82f5fb06d9416267b"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b4a57c11f0293d463a0d64c976b00c2df39e63debbc270c8c4ea334cadd3951"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f8b8ab1dc05160a9cc4b6a05627f006c57be547cd099b993331991e63ffa189"
    sha256 cellar: :any_skip_relocation, monterey:       "266d9edbb579b9fd8cbba4f641e46b22141bddf4add0a3ab041ce6f742f468dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "262c1a6b845b44fc2890b2867698b8046f8885dfa9344500de0f1b1066865c81"
    sha256 cellar: :any_skip_relocation, catalina:       "b90761191a19ae6c21fe93dfb271db266f1a2861de5324b1a2e59d666a2434b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9285891f326507626892d05b624fc198ded86ff35e44777370d97ff567e2510e"
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
    url "https://files.pythonhosted.org/packages/4c/c9/065f97b7e89dcb438ce3e270f3f28af5cba759f4127afe14ce6038701270/pyinstaller-hooks-contrib-2022.4.tar.gz"
    sha256 "b7f7da20e5b83c22219a21b8f849525e5f735197975313208f4e07ff9549cdaf"
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
