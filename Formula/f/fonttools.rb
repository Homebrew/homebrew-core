class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/ec/ca/cf17b88a8df95691275a3d77dc0a5ad9907f328ae53acbe6795da1b2f5ed/fonttools-4.61.1.tar.gz"
  sha256 "6675329885c44657f826ef01d9e4fb33b9158e9d93c537d84ad8399539bc6f69"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20e723d578566cf4d36f9eaddf49958471377be6a644f749e7f0fc1efb0a9e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e36cc0b4614d3436e494b418820d694014337212e03f8793532621db7fa895d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8891a5cc714c80f23224e8efc8a489921c67f64dc7a119fd70c606e03c271051"
    sha256 cellar: :any_skip_relocation, sonoma:        "505a495c7c5ae6e16fc376ca496c7bebf11fa09732debfbb04b8dbe1ec40ba73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abed655df3af8ced33196b2428197f213cc7e068b6068e7fca93b540f3e1ac97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558be6c40d4a9fa264949c4908394af2cf2c4940397f3f3401765727ca43ff43"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages package_name: "fonttools[lxml,woff]"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/be/4c/efa0760686d4cc69e68a8f284d3c6c5884722c50f810af0e277fb7d61621/zopfli-0.4.0.tar.gz"
    sha256 "a8ee992b2549e090cd3f0178bf606dd41a29e0613a04cdf5054224662c72dce6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
