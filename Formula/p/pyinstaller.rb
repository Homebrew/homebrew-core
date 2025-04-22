class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/a8/b1/2949fe6d3874e961898ca5cfc1bf2cf13bdeea488b302e74a745bc28c8ba/pyinstaller-6.13.0.tar.gz"
  sha256 "38911feec2c5e215e5159a7e66fdb12400168bd116143b54a8a7a37f08733456"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "587564f2b16d8a3ddea2a2092dfce0b13a41cf58e754a4005d90e2879c161ee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08f530d0f592cb413f5aeaeb78b4c29c6ecf0fe948ef29bfb893753553789028"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d84b07ebb17fee1edef346faf70d4d70052ed1fdcb9153f2a970607e0b5591a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d9d52524af170915bee4968f4ca8430257894b377cb308dc66c6835771c713f"
    sha256 cellar: :any_skip_relocation, ventura:       "6ae43e011c0829ebb0ba4a972e44a680c10e6e058180abc4d68e2574053b6cbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a284364b0a6ac12e91293ce5b64a9bababcdbdf5044abb5dea1fbb5939e3f623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9acf51b2ade652c578e709190d7c983c639faba1f0c46a4e2cffd15c5bf2eda8"
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
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/99/14/6725808804b52cc2420a659c8935e511221837ad863e3bbc4269897d5b4d/pyinstaller_hooks_contrib-2025.2.tar.gz"
    sha256 "ccdd41bc30290f725f3e48f4a39985d11855af81d614d167e3021e303acb9102"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
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
