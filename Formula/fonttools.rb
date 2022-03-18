class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/9f/30/2fb2156511b227d4ff07b51e3fb216d0cb4bfb3d3ac67fdbee9f39d3b095/fonttools-4.31.0.zip"
  sha256 "1b008d129c1c0f0174a74f2ea07b949ed4fbf328355cf4c9812506ecaac38b9f"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d418f33b6b41b00200bb48e73d9290128f872b73343e13377ae8f6318183b1a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d418f33b6b41b00200bb48e73d9290128f872b73343e13377ae8f6318183b1a0"
    sha256 cellar: :any_skip_relocation, monterey:       "a825048aa08cdbe16a7b909501f8a6e2c5081084ba20d5ee005123d8bfe96cec"
    sha256 cellar: :any_skip_relocation, big_sur:        "a825048aa08cdbe16a7b909501f8a6e2c5081084ba20d5ee005123d8bfe96cec"
    sha256 cellar: :any_skip_relocation, catalina:       "a825048aa08cdbe16a7b909501f8a6e2c5081084ba20d5ee005123d8bfe96cec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b26ac3bb0ab0de60dc5680159a8465b55b4c2d1b896e4e77c0c1da703cf58414"
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
