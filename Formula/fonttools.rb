class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/88/27/418ac6f1b85856608df81fe6e72fbb85929d7b904540056f3061e27bba04/fonttools-4.32.0.zip"
  sha256 "59a90de72149893167e3d552ae2402c6874e006b9adc3feaf5f6d706fe20d392"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e82edee5a404ceb08cf67a147b77d737b6811dba0ada365e790a9ad55bc6fb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e82edee5a404ceb08cf67a147b77d737b6811dba0ada365e790a9ad55bc6fb9"
    sha256 cellar: :any_skip_relocation, monterey:       "fdf6a0452f4d86f4eb8cefa672de82b40ec8555faf1853c7f43e29d238464e4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdf6a0452f4d86f4eb8cefa672de82b40ec8555faf1853c7f43e29d238464e4b"
    sha256 cellar: :any_skip_relocation, catalina:       "fdf6a0452f4d86f4eb8cefa672de82b40ec8555faf1853c7f43e29d238464e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af2b0f4cfc5562afdb27c81113e6200331fa6641eaef921a7d8328393f8a25b"
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
