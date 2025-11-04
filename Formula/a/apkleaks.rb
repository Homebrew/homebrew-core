class Apkleaks < Formula
  include Language::Python::Virtualenv

  desc "Scanning APK file for URIs, endpoints & secrets"
  homepage "https://github.com/dwisiswant0/apkleaks"
  url "https://files.pythonhosted.org/packages/1e/e6/203661abe151dbc59096de65d6f0cf392d1aad3acba32f4e9f3f389acad0/apkleaks-2.6.3.tar.gz"
  sha256 "e247b59acf4448f3c2e45449bc7564bc5b7a216ebfb166236baf602d625b1df5"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30f23d279478263f6ea0e37eee13fead1e2e1cce3bf150987305380f77b40940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7ee44693cf42223aa4b50e7e30e33e5909b9f6c40ef7ccdbd05c12d08fa6bf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be9d388e988d01fd51621e21f1067dbfb739e7a35bbda0fa8ecfedb5697d8848"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1f50e61fc6fbe4267e9c6f3f3f425ff822892a64feb1af5f0e2cbff1e5d1fdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f3014e026d33801dec32e80823fce26797317dd999f16ff6a46a1db2ba495fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af72799417a097e97f6994a393077722ff2f6e0a11dec8716e397b251aa31f94"
  end

  depends_on "jadx"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "pyaxmlparser" do
    url "https://files.pythonhosted.org/packages/1e/1f/7a7318ad054d66253d2b96e2d9038ea920f17c8a9bd687cdcfa16a655bdf/pyaxmlparser-0.3.31.tar.gz"
    sha256 "fecb858ff1fb456466f8dcdcd814207b4c15edb95f67cfe0a38c7d7cd4a28d4d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test.apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    testpath.install resource("homebrew-test.apk")
    output = shell_output("#{bin}/apkleaks -f #{testpath}/redex-test.apk")
    assert_match "Decompiling APK...", output
    assert_match "Scanning against 'com.facebook.redex.test.instr'", output

    assert_match version.to_s, shell_output("#{bin}/apkleaks -h 2>&1")
  end
end
