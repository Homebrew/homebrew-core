class Apkleaks < Formula
  include Language::Python::Virtualenv

  desc "Scanning APK file for URIs, endpoints & secrets"
  homepage "https://github.com/dwisiswant0/apkleaks"
  url "https://files.pythonhosted.org/packages/8e/7f/95822c947138c8fc127d88128fb8fa9b0ed37a7fddf0b840685075ee288e/apkleaks-2.6.1.tar.gz"
  sha256 "47eea4683a9916e4099d05776be2ec3892791f5fd854f49cb5ed489cc9867c62"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa1c9b88288fa187b5fed5349a5f9ad3c3c72c6897aaf75dfa6d81e41c745ff5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d65e0943945ca4f38d19544667e9cf5b4e671a20cbe52215fcb8d60e391a189"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46a59fefc84fe6045b1eafef9f8b9d902a2aad63833147c3c9057ba363007d95"
    sha256 cellar: :any_skip_relocation, sonoma:         "93f8b7983670c50972f582ae49e4d075435e8d1dd1cb179cc5f76c4da6ff6350"
    sha256 cellar: :any_skip_relocation, ventura:        "08c53e1cec50331e0a9cb38c61a092612a92d786b610389bb67be7c8ff26e712"
    sha256 cellar: :any_skip_relocation, monterey:       "c5e9fda0f4401fbbe8773f2f242df3be152ce2607529abd71af22ad5cd4de982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a00fdfa4d66c7740f24705018d49b4a835722a92cac8b4b633df91b860de6c"
  end

  depends_on "jadx"
  depends_on "python-click"
  depends_on "python-lxml"
  depends_on "python@3.12"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "pyaxmlparser" do
    url "https://files.pythonhosted.org/packages/e3/7c/fae519a8eb4e91587b2b4bf9b1ff738451984687a2cfff778df71b74727d/pyaxmlparser-0.3.30.tar.gz"
    sha256 "ce301723fa7f05b3c2869f18f7af9e75abfbda362dc77789f668bb80287c9b3b"
  end

  # Drop distutils/setuptools
  # https://github.com/dwisiswant0/apkleaks/pull/81
  patch do
    url "https://github.com/dwisiswant0/apkleaks/commit/fc8871ac605447db1456cb1189fa79e673f71e1b.patch?full_index=1"
    sha256 "5c0eda68fbba60b9ecb8471f7a3ec92c2cb34988ca98188daad3af572bb09b83"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
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
