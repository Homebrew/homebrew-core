class Apkleaks < Formula
  include Language::Python::Virtualenv

  desc "Scanning APK file for URIs, endpoints & secrets"
  homepage "https://github.com/dwisiswant0/apkleaks"
  url "https://files.pythonhosted.org/packages/40/88/8aa234dd5f7e632605dcce90d076982d4d1124d7278991ee54ec9e543cef/apkleaks-2.6.2.tar.gz"
  sha256 "f6f767dd758d2fd1395186709e736402ab6f913a6172e29220d6581035aa76fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "15d3a77dc564f393dd748b701ebd187b0b71a4d0a38707bcb426938012d977d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "517dfc6f423e2eb7a1c0deba2598bcb907132efe04ca2d71775ffa6ddef65a23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4cb660dc81eabb317ab1c16e595c05436d0237b7202d08f1dc1f8360902dd34"
    sha256 cellar: :any,                 arm64_monterey: "b1ecd3774113cf9c92c3a03e1394572b83f297ddf0b4070c9d2d7df6a32986e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9dbf55df4f43d7f6bdeeead47275103103118abb755c5f3e30a7685e1e841253"
    sha256 cellar: :any_skip_relocation, ventura:        "aab0991cebc6c97ac6bd6200a6bc7deafdf56a6f59bdc899acccc624fe664009"
    sha256 cellar: :any,                 monterey:       "ed06ed10e8816eb47099d18a520c238856402f2a9a08672fdc3f645b7f53d5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee5126a2a63fa15c5aca1a5b10912359fd1d49b736ef3e0510fd89510097b345"
  end

  depends_on "jadx"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
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
