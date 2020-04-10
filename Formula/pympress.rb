class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/92/80/c63ad7748e877dfeb5d7d756c1bdd4c2657e5a857814b4d6edf96d44678c/pympress-1.5.3.tar.gz"
  sha256 "d8c10c286d1de2210c19a3e752542b61c8bcc592c48553f7c7043e943a87d05d"
  head "https://github.com/Cimbali/pympress.git"

  bottle do
    cellar :any
    sha256 "24540ab0f775af92de2f95429dec877d5a97dc1ef61bb9aded8fa4ad356c2e99" => :catalina
    sha256 "fc7a914b18e0b2be1ecef5a05ef60299b70c09b77774aa4cdf5410c6fb0bebb5" => :mojave
    sha256 "7af17f84c899bc000d09c62a4a5658c943a13c0cf56a07a512ab96eaae76b8bf" => :high_sierra
  end

  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.8"

  resource "argh" do
    url "https://files.pythonhosted.org/packages/e3/75/1183b5d1663a66aebb2c184e0398724b624cecd4f4b679cb6e25de97ed15/argh-0.26.2.tar.gz"
    sha256 "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65"
  end

  resource "pathtools" do
    url "https://files.pythonhosted.org/packages/e7/7f/470d6fcdf23f9f3518f6b0b76be9df16dcc8630ad409947f8be2eb0ed13a/pathtools-0.1.2.tar.gz"
    sha256 "7c35c5421a39bb82e58018febd90e3b6e5db34c5443aaaf742b3f33d4655f1c0"
  end

  resource "python-vlc" do
    url "https://files.pythonhosted.org/packages/a8/51/299f4804c43f99d718ed43a63b1ea0712932e25b6bbe1ee1817cb8e954f7/python-vlc-3.0.7110.tar.gz"
    sha256 "821bca0dbe08fbff97a65e56ff2318ad7d499330876579c39f01f3fb38c7b679"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/bb/e3/5a55d48a29300160779f0a0d2776d17c1b762a2039b36de528b093b87d5b/watchdog-0.9.0.tar.gz"
    sha256 "965f658d0732de3188211932aeb0bb457587f04f63ab4c1e33eab878e9de961d"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/pympress"
  end

  test do
    system bin/"pympress", "--help"

    # Version info contained in log file only if all dependencies loaded successfully
    assert_predicate testpath/"Library/Logs/pympress.log", :exist?
    output = (testpath/"Library/Logs/pympress.log").read
    assert_match /^INFO:pympress.__main__:Pympress: #{version}\s*;/, output
  end
end
