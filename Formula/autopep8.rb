class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/d0/5d/016888824972086a4ee164806520d85ff173e83699907b9cfe119aaefbbc/autopep8-1.7.0.tar.gz"
  sha256 "ca9b1a83e53a7fad65d731dc7a2a2d50aa48f43850407c59f6a1a306c4201142"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c52de22dd0b9d9a7773db27b587ee9d27c3cafedc121fe7a0abaa3d1c50605cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c52de22dd0b9d9a7773db27b587ee9d27c3cafedc121fe7a0abaa3d1c50605cc"
    sha256 cellar: :any_skip_relocation, monterey:       "282206f1a762ce0bcead1bac457509057287548089b3d16c2ca032de98deca37"
    sha256 cellar: :any_skip_relocation, big_sur:        "282206f1a762ce0bcead1bac457509057287548089b3d16c2ca032de98deca37"
    sha256 cellar: :any_skip_relocation, catalina:       "282206f1a762ce0bcead1bac457509057287548089b3d16c2ca032de98deca37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "548a6fadf6bcc710185bbd29d444a45cab853b29817949f1208a58bd292c9bc3"
  end

  depends_on "python@3.10"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/b6/83/5bcaedba1f47200f0665ceb07bcb00e2be123192742ee0edfb66b600e5fd/pycodestyle-2.9.1.tar.gz"
    sha256 "2c9607871d58c76354b697b42f5d57e1ada7d261c261efac224b664affdc5785"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
