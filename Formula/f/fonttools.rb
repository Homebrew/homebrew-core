class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/a4/6e/681d39b71d5f0d6a1b1dc87d7333331f9961b5ab6a2ad6372d6cf3f8b04c/fonttools-4.53.0.tar.gz"
  sha256 "c93ed66d32de1559b6fc348838c7572d5c0ac1e4a258e76763a5caddd8944002"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c31e81701054f6b50061018960927f24974fa5ac1a419e97313c0b7a85f8ba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56ea788f4208e9cee4c8260c2ffe52751e9a50ec012d7da0291423e90175d23e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0c14c62065a42356d87ad82790dc7515cb09ffd248129bc0f46d015e7c12e6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f84e6aac694b073fe2fe00087528ff665b6fdf47ea054f22bc393ac5758c3849"
    sha256 cellar: :any_skip_relocation, ventura:        "87e48ea12a81d4a3be2a44876512fd1bc69cd2acabf4c3f79c4f6810160aa264"
    sha256 cellar: :any_skip_relocation, monterey:       "88ba0bb8d685c70c1db9b13b1e61614521ab33d75c29dc5d47a22018a6d6a201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dac549f8fd4299fcfad76bb3c0564e9746469fd0b1bd89bb43898b24cec1c5c0"
  end

  depends_on "python@3.12"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/92/d8/71230eb25ede499401a9a39ddf66fab4e4dab149bf75ed2ecea51a662d9e/zopfli-0.2.3.zip"
    sha256 "dbc9841bedd736041eb5e6982cd92da93bee145745f5422f3795f6f258cdc6ef"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.ttx", :exist?
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
