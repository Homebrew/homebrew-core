class NameThatHash < Formula
  include Language::Python::Virtualenv

  desc "Modern hash identification system"
  homepage "https://nth.skerritt.blog/"
  url "https://files.pythonhosted.org/packages/22/ea/77115c555b73ef67deb3fd642a03dc83ef91b4b4790daf6f3ac5ee8f8274/name-that-hash-1.1.1.tar.gz"
  sha256 "4a9db2b35540ac77b96239bcce4e1ae1fc1c06cd4b71605ecbc3315f27883b9a"
  license "GPL-3.0-or-later"
  head "https://github.com/HashPals/Name-That-Hash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "981d9084784254b087c7337fa7fc0c5f21a4fa8656a9d85da2fe55be3c627a92"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee865adb3997432fde088bb2f777ee4d5e639a65ae0fac793e32eadc0e2bd910"
    sha256 cellar: :any_skip_relocation, catalina:      "3449a3ee1a4cb493ae42a11ba2f96316980dcee2600c99f49220ff647eea33c8"
    sha256 cellar: :any_skip_relocation, mojave:        "777f25e52b9bc16c20e8ce439240bc73b0f7e0592cec1b7d1e2577fd480661f8"
  end

  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/6d/25/0d65383fc7b4f4ce9505d16773b2b2a9f0f465ef00ab337d66afff47594a/loguru-0.5.3.tar.gz"
    sha256 "b28e72ac7a98be3d28ad28570299a393dfcd32e5e3f6a353dec94675767b6319"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/19/d0/dec5604a275b19b0ebd2b9c43730ce39549c8cd8602043eaf40c541a7256/Pygments-2.8.0.tar.gz"
    sha256 "37a13ba168a02ac54cc5891a42b1caec333e59b66addb7fa633ea8a6d73445c0"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/7b/5a/5ade9c4713b1745970b6276b6c7d5ae37d0cafd453c6c4f1a4b44833980a/rich-9.11.0.tar.gz"
    sha256 "f8f08fdac6bd67dc2dd7fe976da702d748487aa9eb5d050c48b2321bc67ed659"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}/nth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "MD5, HC: 0 JtR: raw-md5 Summary: Used for Linux Shadow files.\n", output
  end
end
