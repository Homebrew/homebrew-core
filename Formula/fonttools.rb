class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/cb/d9/8f4b6d56afb0c034c65a12902df9d7b41e1ede88bf89baf19d172e9396c3/fonttools-4.31.2.zip"
  sha256 "236b29aee6b113e8f7bee28779c1230a86ad2aac9a74a31b0aedf57e7dfb62a4"
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
