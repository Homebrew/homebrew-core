class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/65/4b/e1984498760eaf9808e1e019fb8a1182d8e9a1ac519fbc11c73aa958f53d/fonttools-4.23.1.zip"
  sha256 "cc10e3d129aab606d2a85ea7e6b74baa91ecdd4f315cd4f2c39481beeb9040c3"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6552130275ee054e78aa046d2e9887eb5f08d05e7a80c5f6161bf267852558a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2d9214026090858431c4330f7a73682cdc7d51af0aa6ecc0887b0fe70b700aa"
    sha256 cellar: :any_skip_relocation, catalina:      "b2d9214026090858431c4330f7a73682cdc7d51af0aa6ecc0887b0fe70b700aa"
    sha256 cellar: :any_skip_relocation, mojave:        "b2d9214026090858431c4330f7a73682cdc7d51af0aa6ecc0887b0fe70b700aa"
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
