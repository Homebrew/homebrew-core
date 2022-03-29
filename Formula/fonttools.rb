class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/cb/d9/8f4b6d56afb0c034c65a12902df9d7b41e1ede88bf89baf19d172e9396c3/fonttools-4.31.2.zip"
  sha256 "236b29aee6b113e8f7bee28779c1230a86ad2aac9a74a31b0aedf57e7dfb62a4"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3913aa62ccdda0caf2bcd613fc0a2d2592f182e2e3fe560d722b7876c224371a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3913aa62ccdda0caf2bcd613fc0a2d2592f182e2e3fe560d722b7876c224371a"
    sha256 cellar: :any_skip_relocation, monterey:       "8ed42c1a2f9f955399ab4b7db0b9ef724d0bc1ba1ca77e09e748a3486b21ed7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ed42c1a2f9f955399ab4b7db0b9ef724d0bc1ba1ca77e09e748a3486b21ed7a"
    sha256 cellar: :any_skip_relocation, catalina:       "8ed42c1a2f9f955399ab4b7db0b9ef724d0bc1ba1ca77e09e748a3486b21ed7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1c3605a0fb146fd2f0aded0bd06f833889dbd766e79d8edf4845e729978ff58"
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
