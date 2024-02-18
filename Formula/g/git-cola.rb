class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/ff/9d/535817104a93cea22d4b7bc9fafd342a5370ec4c0ea3e10a0870d8bb817a/git-cola-4.5.0.tar.gz"
  sha256 "2fb8db5c2cd5558dafa966fad54678301b7c2dbb1c47eb7b1a548de7da6ce2ec"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d1677acba66d6928d1d90b34b0f1e1c0907f62f314d27ce220bc3d17b23f8a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb5d7bd557b837a05733c066462cd758837d1300cef40af349e4dad877d70949"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "227239100a3976ca37bb0709aa76d2261ee376b61ff65e163f3ab1689f503fba"
    sha256 cellar: :any_skip_relocation, sonoma:         "37420366803243fbf8df751d02e940cd7cbed0943bb3bfe532a5f036a63139c0"
    sha256 cellar: :any_skip_relocation, ventura:        "f0f784f1ef29cf3f385b5128b938659dc04b4d4a7f7a5a9007423d812ef8fc22"
    sha256 cellar: :any_skip_relocation, monterey:       "e224a477ec0bcccb299bfdd30be254dca34fc0efa8282188e080c92dd7c4e863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13966e13290c9616203e0dd73329c56e02be3537b4e904a89a6058a3e15eda87"
  end

  depends_on "pyqt"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"

  resource "qtpy" do
    url "https://files.pythonhosted.org/packages/eb/9a/7ce646daefb2f85bf5b9c8ac461508b58fa5dcad6d40db476187fafd0148/QtPy-2.4.1.tar.gz"
    sha256 "a5a15ffd519550a1361bdc56ffc07fda56a6af7292f17c7b395d4083af632987"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
