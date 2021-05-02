class NameThatHash < Formula
  include Language::Python::Virtualenv

  desc "Modern hash identification system"
  homepage "https://nth.skerritt.blog/"
  url "https://files.pythonhosted.org/packages/c5/f2/d845308790348ef09cd8ba3f9b04fde0120cb1615aba499f791d5d26d4c2/name-that-hash-1.8.0.tar.gz"
  sha256 "f1f11dce70e0baf7521245abb4eb3a1563dac637791369561c5daba1aeb7fc97"
  license "GPL-3.0-or-later"
  head "https://github.com/HashPals/Name-That-Hash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "652eb551f5f2808ecff117d16fdc95abb92b56307e43e4268b0a15bb2fbd1f2c"
    sha256 cellar: :any_skip_relocation, big_sur:       "00cf64cfaa275335b30beb38a119fde7a50235d96c7c7efd09b9e7709561cf47"
    sha256 cellar: :any_skip_relocation, catalina:      "7a834f9d4a75eb7be2b40e8c987a2b3e5fddd6a1353cc3a0b6047b83ad8619e0"
    sha256 cellar: :any_skip_relocation, mojave:        "97ebb3df39e1d24798c6dfe0077f280cb8055119d853980494df9fa293de014b"
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

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/12/3c/e4e2b356057f3ce557fcda8a2b9bf114b06f71ade88dac8a0883ae800e28/rich-10.1.0.tar.gz"
    sha256 "8f05431091601888c50341697cfc421dc398ce37b12bca0237388ef9c7e2c9e9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/aa/55/62e2d4934c282a60b4243a950c9dbfa01ae7cac0e8d6c0b5315b87432c81/typing_extensions-3.10.0.0.tar.gz"
    sha256 "50b6f157849174217d0656f99dc82fe932884fb250826c18350e159ec6cdf342"
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
