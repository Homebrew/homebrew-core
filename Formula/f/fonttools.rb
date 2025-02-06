class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/f1/24/de7e40adc99be2aa5adc6321bbdf3cf58dbe751b87343da658dd3fc7d946/fonttools-4.55.8.tar.gz"
  sha256 "54d481d456dcd59af25d4a9c56b2c4c3f20e9620b261b84144e5950f33e8df17"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "343a862a1a403259c3e3167c0faf04bdb658f97f4e5a08c1733d56f8f889076b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0eb50e9ecc50f349c116a7a843745db6d34dfd7e5aa72bfd20f402dcd800a77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76b8abe2240ed792e7ed89f0b12029ad4479788589b36ec289c3f593547ed552"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff104e2c3cdaaa19d2db19431eff2dc25f8d3cdde8402affa2e8d7c5bb0ebae7"
    sha256 cellar: :any_skip_relocation, ventura:       "f85b9b3a1f6b4423d581df4f6def34cc35407ac288b96f17322630204b79e03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3209322c7f656833c6fd29f14f773ae91a2e04d96f2212a9baf94c7b85cec1c0"
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
      assert_predicate testpath/"ZapfDingbats.ttx", :exist?
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
