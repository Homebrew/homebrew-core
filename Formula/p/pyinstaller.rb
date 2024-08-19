class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/5c/df/30b1f66d35defa37e676556acca4eb775b49637bb73054b0c31af134cd8a/pyinstaller-6.10.0.tar.gz"
  sha256 "143840f8056ff7b910bf8f16f6cd92cc10a6c2680bb76d0a25d558d543d21270"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3388ed6f59a3abbc81b26edc41f5b5bd99b9271a6f38e127cf77750f15b8f85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74f6268571e4252c615c5c7eb1a107adaeaa72777c43b310e2785d08ac98153e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c301668a3b25babf253ce9ada3518008064fc2f84b3b6fd253cbf6e72f628976"
    sha256 cellar: :any_skip_relocation, sonoma:         "eebdbac8ca69726b6387e8e2ecf9ba94d287bc4f2c17b52476dc7c055b3e5223"
    sha256 cellar: :any_skip_relocation, ventura:        "00c71cc368c6565d6a6bec53985bd729d72e2c48d869ea319df989cb78cbfe62"
    sha256 cellar: :any_skip_relocation, monterey:       "34b4a2191dfa72043970f31e6c52cd19eaf35131fb5ba4f84b5086faa3c6c52a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c4298d59c77445c098f9737989205853007bef0065797f6eb1a1b2a41a41937"
  end

  depends_on "python@3.12"

  uses_from_macos "zlib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/20/17/58309bc981794907429f352ed628008db5ead987dafc5b2bfb318804a949/pyinstaller_hooks_contrib-2024.8.tar.gz"
    sha256 "29b68d878ab739e967055b56a93eb9b58e529d5b054fbab7a2f2bacf80cef3e2"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/5e/11/487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1d/setuptools-72.1.0.tar.gz"
    sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  end

  def install
    cd "bootloader" do
      system "python3.12", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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
