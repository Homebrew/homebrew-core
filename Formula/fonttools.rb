class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/af/c1/e4371eba2a9291bac65d6c5729ba0cf8ebf29d294b5bbb84210205bd3f01/fonttools-4.24.0.zip"
  sha256 "a77b5c1cf6db4adbe0c67574cc314af2f3a439aeaf6e7607177c0eb78c36a200"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bdd5de166ecc0b56bb1fee38122d58f226d88ada65b551fe932b7638ff62d00f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b650fa20f73356d7b6e1b441829b9161d214a4256dbcf116666ee0ea78777724"
    sha256 cellar: :any_skip_relocation, catalina:      "b650fa20f73356d7b6e1b441829b9161d214a4256dbcf116666ee0ea78777724"
    sha256 cellar: :any_skip_relocation, mojave:        "b650fa20f73356d7b6e1b441829b9161d214a4256dbcf116666ee0ea78777724"
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
