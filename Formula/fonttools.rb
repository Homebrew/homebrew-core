class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/15/10/c087a7e87346332e40ef24f2a18e3b288b0c0e8196c02e06f94ba4d964b7/fonttools-4.26.2.zip"
  sha256 "c1c0e03dd823e9e905232e875ea02dbb2dcd2ba195418c6d11bfaea49b9c774d"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9110168b0c239e2deb66d6b28b42204a965a714d38a500d8f89c273b0946e740"
    sha256 cellar: :any_skip_relocation, big_sur:       "adf628d7849203f72a49a2a1c13385e2135805b0bb9aa56c1da18fded4354935"
    sha256 cellar: :any_skip_relocation, catalina:      "adf628d7849203f72a49a2a1c13385e2135805b0bb9aa56c1da18fded4354935"
    sha256 cellar: :any_skip_relocation, mojave:        "adf628d7849203f72a49a2a1c13385e2135805b0bb9aa56c1da18fded4354935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17be4952fb6a4a7b443ee9617965fdbdc0e40834ac4c4e2efbc3925a95195c6a"
  end

  depends_on "python@3.9"

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
