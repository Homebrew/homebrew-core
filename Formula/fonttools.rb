class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/f2/7f/415cc06c4278bbcda5c37b3e905fb1a2b9e63d93412c8531c12ca0628817/fonttools-4.33.1.zip"
  sha256 "66dd757b8a9d7b07d61c22b8d973282990c45343572b88e5fc722b3a8272598e"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5886d671e8a7276f8580336cd511d1d63cfe4565744d8920ba7aaded188d31e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5886d671e8a7276f8580336cd511d1d63cfe4565744d8920ba7aaded188d31e1"
    sha256 cellar: :any_skip_relocation, monterey:       "dbaf42cd93880575a165a518b959258ca5f59e0637d533cac6ffd3c5a401005c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbaf42cd93880575a165a518b959258ca5f59e0637d533cac6ffd3c5a401005c"
    sha256 cellar: :any_skip_relocation, catalina:       "dbaf42cd93880575a165a518b959258ca5f59e0637d533cac6ffd3c5a401005c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3a0af318660ac5ce6f680194aeeb0648980c7a531a29ea56707202839ee5b08"
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
