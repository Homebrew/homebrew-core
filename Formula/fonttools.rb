class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/2d/4c/49ba863863502bb9fea19d8bd04a527da336b4a2698c8a0c7129e9cc2716/fonttools-4.29.1.zip"
  sha256 "2b18a172120e32128a80efee04cff487d5d140fe7d817deb648b2eee023a40e4"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89af4e914597f6c8964ea1bfb9c8538747ac81794b926c85d1d92cb31c94fdbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89af4e914597f6c8964ea1bfb9c8538747ac81794b926c85d1d92cb31c94fdbc"
    sha256 cellar: :any_skip_relocation, monterey:       "c29f5b23b4afdbe80f3903490d930a79104adb00cc25739af43f75b1b39a416f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c29f5b23b4afdbe80f3903490d930a79104adb00cc25739af43f75b1b39a416f"
    sha256 cellar: :any_skip_relocation, catalina:       "c29f5b23b4afdbe80f3903490d930a79104adb00cc25739af43f75b1b39a416f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce5e36f8480a3c4b4acd6a9e1752998f0c8bb6979ae07f574268226f1025333b"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
