class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/03/2d/a9a0b6e3a0cf6bd502e64fc16d894269011930cabfc89aee20d1635b1441/fonttools-4.57.0.tar.gz"
  sha256 "727ece10e065be2f9dd239d15dd5d60a66e17eac11aea47d447f9f03fdbc42de"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bcab45edee79e069d02ee940ec0f75956ec84bffedaf905c9f9bab1a3b12fe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d998181d00fc650f37eaba9b60e586c0d14326370de1efde8232428635cead3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0bc508444fe4d4fac252804e51e1126c3c390a8e0bf37b38f20fd96e1ed6d96"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b83bfbf26a37cab5243519b0efc97142a737a8b1f225ffd23b3a17e585bb11c"
    sha256 cellar: :any_skip_relocation, ventura:       "09eed9216730c07039bcbd44277e51a3d3440665f03a8d394b3c67c65bb96496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77f83536bf774f78ff15cf658ad545acf8c167763bbeed5ab01ef2fa6d7680b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa3d1366e4830060a1ba3dc81238281b45c9ca517d6a7360748c61b757c7ee9"
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
