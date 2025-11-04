class Apkleaks < Formula
  include Language::Python::Virtualenv

  desc "Scanning APK file for URIs, endpoints & secrets"
  homepage "https://github.com/dwisiswant0/apkleaks"
  url "https://files.pythonhosted.org/packages/1e/e6/203661abe151dbc59096de65d6f0cf392d1aad3acba32f4e9f3f389acad0/apkleaks-2.6.3.tar.gz"
  sha256 "e247b59acf4448f3c2e45449bc7564bc5b7a216ebfb166236baf602d625b1df5"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1d47054ac171bb39a0dfac7971bee89f16e2b132939238516253626f00c0fa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8ccba254372a410048df881690db842753db0d1cf44f6c949794eed76b6f949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01db0cc2ba78d06e07a2dc9845d6a32537aff975e85f30a9c95940a2e76e32dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "76049852fe10e2f7b4709f727f05eab86ae32aa3ae69bda6e1c8d8c5f13bbf38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49af4612bade044c39289d429d0eb0d90e10e02fbef12b91147ecc3ef4c2616e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9720c048f854f1b5b8491c9a7857dc0d09400c7c092d6f06e32b6c4e2cea4c07"
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
