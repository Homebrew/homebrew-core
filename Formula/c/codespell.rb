class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/b0/2f/706691245790ae6c63252d48b7ff5e3635951d55b3ce3c0ac13d898bf70b/codespell-2.4.0.tar.gz"
  sha256 "587d45b14707fb8ce51339ba4cce50ae0e98ce228ef61f3c5e160e34f681be58"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "743ad79b4e6045a50f6778b193d430d1e98d5fa56bde864696fba56c1a0aafb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "743ad79b4e6045a50f6778b193d430d1e98d5fa56bde864696fba56c1a0aafb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "743ad79b4e6045a50f6778b193d430d1e98d5fa56bde864696fba56c1a0aafb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6c275235fc65504e970a0110ca92e58350df5fa576de6edbdffe2412cf5bbc8"
    sha256 cellar: :any_skip_relocation, ventura:       "f6c275235fc65504e970a0110ca92e58350df5fa576de6edbdffe2412cf5bbc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "743ad79b4e6045a50f6778b193d430d1e98d5fa56bde864696fba56c1a0aafb5"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
