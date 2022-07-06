class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/a4/c9/1ce7e091543c090ef7cd6f3e6662815cafaf76071c96a00b380566759f06/fonttools-4.34.2.zip"
  sha256 "3fb3bef8e743dad8fe96e12a47a9ce9bd367ac0a24c089256615518c88309dbd"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e5bbba05a480503fcf080020c2219845a09d96405c26848c32db3853d26763f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e5bbba05a480503fcf080020c2219845a09d96405c26848c32db3853d26763f"
    sha256 cellar: :any_skip_relocation, monterey:       "4775faf036ce2a85143a1d258664d37abcf29782b6c7c41d3448039617568fe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4775faf036ce2a85143a1d258664d37abcf29782b6c7c41d3448039617568fe7"
    sha256 cellar: :any_skip_relocation, catalina:       "4775faf036ce2a85143a1d258664d37abcf29782b6c7c41d3448039617568fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa910775b3433a5cf1be6614a0a51689da62528c42091ff06d3a5c5c641a4346"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
