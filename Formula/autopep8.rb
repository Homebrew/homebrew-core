class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/4a/73/c9994ebcaaec5380513a107bcbd2e792a37c37c589ef9e63ae8fa6a28056/autopep8-1.7.1.tar.gz"
  sha256 "f0058220e4cc0ef6121996fc8ec1c32f0735e446be23c4e1f692de0bf23174dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0692f2c2fa9a3bd285cd0ffa73481170fa37ba8780e4f199fb288deb8a78d5a4"
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

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
