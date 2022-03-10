class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/0c/8e/65fddcb0fde840ca335b75a321b2083f35f3e2f08067ee8c21a53769bd66/fonttools-4.30.0.zip"
  sha256 "084dd1762f083a1bf49e41da1bfeafb475c9dce46265690a6bdd33290b9a63f4"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e29b9eaecce4bc74d4944c246c6631fa964a6f952fb15ae65b0be1903e018d7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e29b9eaecce4bc74d4944c246c6631fa964a6f952fb15ae65b0be1903e018d7d"
    sha256 cellar: :any_skip_relocation, monterey:       "cff987a6945ba6ee67e43cb5f23aa0a5da3f15ed84f1c84ebb462eccd60582ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "cff987a6945ba6ee67e43cb5f23aa0a5da3f15ed84f1c84ebb462eccd60582ce"
    sha256 cellar: :any_skip_relocation, catalina:       "cff987a6945ba6ee67e43cb5f23aa0a5da3f15ed84f1c84ebb462eccd60582ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8fe59143975b225be78d08b05e260299b8f41a1e447b9a7f4ca043be8729a44"
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
