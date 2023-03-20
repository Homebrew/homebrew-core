class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/0b/f9/fbd1287671d35f8984be7952d61c0d968df9794e2d5009513424201d9264/fonttools-4.39.2.zip"
  sha256 "e2d9f10337c9e3b17f9bce17a60a16a885a7d23b59b7f45ce07ea643e5580439"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28adc41013dc88c1b016d5d6e46a5be98f39f1c2e2e7dae72460c287c212a565"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb28656d2bb03dcc67d7b5a6efa9a47c2a44a9600c987209a2c9496a2fbd56d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbc8ace4d1c8e0d4defd68a6fa6e1a738b06e1e2e927d699136ef73f4cccc28d"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b450c8e6dbd9feff01de12a3f54816012ff7255c174e9c92cdb5b19314db84"
    sha256 cellar: :any_skip_relocation, monterey:       "5c02a4e2b3193128e017a87740f363bfaea7e9db6387ce07aa320e8dd597ec4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "436253baaf064ea682faa3613384f2f16cc7ae49c977dbecdd6e1c40655c71a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe39d937dd2feee5fde9c7399013d991e2512665e910bdd5e577eafee31a7f48"
  end

  depends_on "python@3.11"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
