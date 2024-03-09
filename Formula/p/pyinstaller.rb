class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/6b/28/fd5fae03e5bc795ff1901bd8d82a7f6d1f7f2a40904cbbe574a31d31c9d7/pyinstaller-6.5.0.tar.gz"
  sha256 "b1e55113c5a40cb7041c908a57f212f3ebd3e444dbb245ca2f91d86a76dabec5"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42e167d1f9179823ceb6443242b12f692653df1d72a98b5f68d199f7b44a8349"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae045f87ea12144c643802d4db7fa4b0dd0c7a9d37e880d026d7610eaa1a1310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cc718099f7bc1229c4db2f6595516a9a2c72961118693cd65240fc1846357e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "704fb7e89b646400d428f4f579874fe17c368165967f629f2ffde7e9dd4a36c8"
    sha256 cellar: :any_skip_relocation, ventura:        "73774d092a48269c38c331f8e6a1987b815ea0e58db56d10c9abf7d8777c4f23"
    sha256 cellar: :any_skip_relocation, monterey:       "2a3dcda9ce0efa9ceb3d4ca50494f7be764c5162941cc1acd07ab2431b800750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d86ca33bf0f69ffa68c176143395bf4cf794bb2c2c5ee51fe912da549e96ecb2"
  end

  depends_on "python@3.12"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/63/e2/11b016c54e9c79d4027693241f3fbfe326006bc030f94c43363491d3ba98/pyinstaller-hooks-contrib-2024.3.tar.gz"
    sha256 "d18657c29267c63563a96b8fc78db6ba9ae40af6702acb2f8c871df12c75b60b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
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
