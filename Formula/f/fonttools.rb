class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/1c/8c/9ffa2a555af0e5e5d0e2ed7fdd8c9bef474ed676995bb4c57c9cd0014248/fonttools-4.56.0.tar.gz"
  sha256 "a114d1567e1a1586b7e9e7fc2ff686ca542a82769a296cef131e4c4af51e58f4"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ba34459e64326124382fff0cd301348d62619ef70dad64fe0bcaed3c641033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fc98e80b6aaafe8b852954bb3d9b12bc82d6bbf1658b6d210fe32fb87db64e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc45b11ac5b23e27ed420660d66b5d1185f2f987b9962866476deaf51c36b209"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff809f1f4207d28dd5f91cea615302a2d62052ad077a77e45382f406b933e2c1"
    sha256 cellar: :any_skip_relocation, ventura:       "dbbb69addadc5fe910e44d27057975defca804f759fd1b55d624f9d24c9d22ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60ee4762156e4e54b7ac029d08b0790c20c4138e6b467b1f08963fe3c11b8d48"
  end

  depends_on "python@3.13"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/5e/7c/a8f6696e694709e2abcbccd27d05ef761e9b6efae217e11d977471555b62/zopfli-0.2.3.post1.tar.gz"
    sha256 "96484dc0f48be1c5d7ae9f38ed1ce41e3675fd506b27c11a6607f14b49101e99"
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
