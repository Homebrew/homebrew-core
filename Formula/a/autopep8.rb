class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/0e/11/7f4fe3b6ce04a073ce093413f8ddaedc253feebafaabd24e0faa1eb7739d/autopep8-2.2.0.tar.gz"
  sha256 "d306a0581163ac29908280ad557773a95a9bede072c0fafed6f141f5311f43c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de7181384ec894d400ba1798d1c5fb718f3f2573dea8bb2b7050372447a1c564"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de7181384ec894d400ba1798d1c5fb718f3f2573dea8bb2b7050372447a1c564"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de7181384ec894d400ba1798d1c5fb718f3f2573dea8bb2b7050372447a1c564"
    sha256 cellar: :any_skip_relocation, sonoma:         "de7181384ec894d400ba1798d1c5fb718f3f2573dea8bb2b7050372447a1c564"
    sha256 cellar: :any_skip_relocation, ventura:        "de7181384ec894d400ba1798d1c5fb718f3f2573dea8bb2b7050372447a1c564"
    sha256 cellar: :any_skip_relocation, monterey:       "de7181384ec894d400ba1798d1c5fb718f3f2573dea8bb2b7050372447a1c564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec3dc2bda69926f945d0eadba16f223b0bcfef9f15c3dbfddce05604c21a7274"
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
