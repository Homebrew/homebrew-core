class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/54/0d/d3759728d25bd4f6e0ed5dee684d08fe74b8ee0058025059a95f51a65feb/fonttools-4.31.1.zip"
  sha256 "f8b35ed9ba189710994cec2c86b8eb5f0c49336698575e439a0d5671d3ca1ace"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2addebc33ca3416cc16f52530e1b50ad1bf94c5a35e16bb83ab4d86ea28befd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2addebc33ca3416cc16f52530e1b50ad1bf94c5a35e16bb83ab4d86ea28befd"
    sha256 cellar: :any_skip_relocation, monterey:       "f950fcfc20e93d372820e12048a7b0bac653c587fa9687c317ad0857f515ff24"
    sha256 cellar: :any_skip_relocation, big_sur:        "f950fcfc20e93d372820e12048a7b0bac653c587fa9687c317ad0857f515ff24"
    sha256 cellar: :any_skip_relocation, catalina:       "f950fcfc20e93d372820e12048a7b0bac653c587fa9687c317ad0857f515ff24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "768262c4edd7698c7574805098bca86c14d81066b8125844a1bc23d11cbbb54e"
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
