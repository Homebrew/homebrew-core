class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/32/23/3bc0b99f932155c19e8b6b4f01021b735727ee6b0ccda6b8e5f99bef1b6d/autopep8-1.5.5.tar.gz"
  sha256 "cae4bc0fb616408191af41d062d7ec7ef8679c7f27b068875ca3a9e2878d5443"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "abf487f3114b67ebfe0760421a3df96e948fbcb2ec378cd2fcab08e2d73aaf49"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d9286b07276cd78d5fb31ed9bd126b5675ffb9b8509793f17d49a571e44b49b"
    sha256 cellar: :any_skip_relocation, catalina:      "7445d78c6c97dad32d841a2afaa2f655d1514b72eca5650460d1d1a8f175e1fe"
    sha256 cellar: :any_skip_relocation, mojave:        "b3ea685a6f92eb1c2b283a38c54a1155fe06fc3f0f7374c8a99ffcbd483286c8"
  end

  depends_on "python@3.9"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/bb/82/0df047a5347d607be504ad5faa255caa7919562962b934f9372b157e8a70/pycodestyle-2.6.0.tar.gz"
    sha256 "c58a7d2815e0e8d7972bf1803331fb0152f867bd89adf8a01dfd55085434192e"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
