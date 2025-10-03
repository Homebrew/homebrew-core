class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/94/94/1f62e95e4a28b64cfbb5b922ef3046f968b47170d37a1e1a029f56ac9cb4/pyinstaller-6.16.0.tar.gz"
  sha256 "53559fe1e041a234f2b4dcc3288ea8bdd57f7cad8a6644e422c27bb407f3edef"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d5afffde148fec469297828d18d4bf79f14deebd3802cc9d9f87322a604f8b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b776bcc4d5a00a3211ed258823b384a2b4aac564923ba3d179f237556308e245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0cfa4638eaacc97a6d34e1c6ac260a78a1392d2649b7be16f01d5085b6ec6f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "40d116db9cf1f2ac2bb80ffabe83b77891605d612d090cb7b6e0f0bfa2c3a5e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e52edd4b8c8ca5fcaf2a34c968bd9cbfb5bdd9780f4a6370250baf996e6d00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57aacbe48d2cc7d832eb552fa8cdecddc769affb4d50d126c80737c7cfa30a0f"
  end

  depends_on "python@3.13"

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
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/71/d6/e5b378b7d4add8c879295c531309b0320e9c07a70458665d091760ffdc87/pyinstaller_hooks_contrib-2025.8.tar.gz"
    sha256 "3402ad41dfe9b5110af134422e37fc5d421ba342c6cb980bd67cb30b7415641c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    cd "bootloader" do
      system "python3.13", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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
