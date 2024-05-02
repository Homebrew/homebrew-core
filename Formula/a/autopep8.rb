class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/4a/65/d187da76e65c358654a1bcdc4cbeb85767433e1e3eb67c473482301f2416/autopep8-2.1.0.tar.gz"
  sha256 "1fa8964e4618929488f4ec36795c7ff12924a68b8bf01366c094fc52f770b6e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "415d815c9b4e5ee07c93dd0cf243ba53d4a000fad65666282860584ccc6c91b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "415d815c9b4e5ee07c93dd0cf243ba53d4a000fad65666282860584ccc6c91b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "415d815c9b4e5ee07c93dd0cf243ba53d4a000fad65666282860584ccc6c91b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "415d815c9b4e5ee07c93dd0cf243ba53d4a000fad65666282860584ccc6c91b6"
    sha256 cellar: :any_skip_relocation, ventura:        "415d815c9b4e5ee07c93dd0cf243ba53d4a000fad65666282860584ccc6c91b6"
    sha256 cellar: :any_skip_relocation, monterey:       "415d815c9b4e5ee07c93dd0cf243ba53d4a000fad65666282860584ccc6c91b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42c6fabcffce03e577b1ba5417255ab1a80206828aea8bc1286a82b5bbe66e69"
  end

  depends_on "python@3.12"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/34/8f/fa09ae2acc737b9507b5734a9aec9a2b35fa73409982f57db1b42f8c3c65/pycodestyle-2.11.1.tar.gz"
    sha256 "41ba0e7afc9752dfb53ced5489e89f8186be00e599e712660695b7a75ff2663f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
