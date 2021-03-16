class NameThatHash < Formula
  include Language::Python::Virtualenv

  desc "Modern hash identification system"
  homepage "https://nth.skerritt.blog/"
  url "https://files.pythonhosted.org/packages/fc/55/bee2efcd3f44b0dd7d6bb155f19e29e9cb9d7ac4a92ba74e5f7b15c3c72e/name-that-hash-1.4.0.tar.gz"
  sha256 "ebe1595978fe1b8ada053225541c23fb90e7c4e78255549ded0799e6eae03e01"
  license "GPL-3.0-or-later"
  head "https://github.com/HashPals/Name-That-Hash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35845d8a066580258423197371767f2419acd8684d7015f735d4db6cc0c3fede"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d295031d86551a3d9dc8ddef2c67198fa3d5841b139dbed39d4de6ea2b1bee6"
    sha256 cellar: :any_skip_relocation, catalina:      "66d206ee9301339de952b78e439c63a7a785b2e5c6e72e3170f9cc4a4a81822a"
    sha256 cellar: :any_skip_relocation, mojave:        "765350747b6e759fed4ca5d9408cd64a2a0cc7e957284df9f61eea9f09186b4c"
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
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ae/f6/6ffb46f6cf0bb584e44279accd3321cb838b78b324031feb8fd9adf63ed2/rich-9.13.0.tar.gz"
    sha256 "d59e94a0e3e686f0d268fe5c7060baa1bd6744abca71b45351f5850a3aaa6764"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  def install
    virtualenv_install_with_resources

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-name_that_hash.pth").write pth_contents
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}/nth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "MD5, HC: 0 JtR: raw-md5 Summary: Used for Linux Shadow files.\n", output

    system Formula["python@3.9"].opt_bin/"python3", "-c", "from name_that_hash import runner"
  end
end
