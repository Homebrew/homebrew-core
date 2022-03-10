class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/0c/8e/65fddcb0fde840ca335b75a321b2083f35f3e2f08067ee8c21a53769bd66/fonttools-4.30.0.zip"
  sha256 "084dd1762f083a1bf49e41da1bfeafb475c9dce46265690a6bdd33290b9a63f4"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4b176eeca51813664f0d9876c7c2eed3fd6a90ebcfe2f96777ed1ae0a0275da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4b176eeca51813664f0d9876c7c2eed3fd6a90ebcfe2f96777ed1ae0a0275da"
    sha256 cellar: :any_skip_relocation, monterey:       "403da3de932fc149eab4cc8f79dee0ad5182bb4332f47a9039cbb7ba1a598977"
    sha256 cellar: :any_skip_relocation, big_sur:        "403da3de932fc149eab4cc8f79dee0ad5182bb4332f47a9039cbb7ba1a598977"
    sha256 cellar: :any_skip_relocation, catalina:       "403da3de932fc149eab4cc8f79dee0ad5182bb4332f47a9039cbb7ba1a598977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21671d0da749232edeb535bc198fb3545ec214590a5749c3f2c2d9a19e3339cf"
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
