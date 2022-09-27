class MarkdownUp < Formula
  include Language::Python::Virtualenv

  desc "The command-line launcher for MarkdownUp, a Markdown viewer"
  homepage "https://github.com/craigahobbs/markdown-up#readme"
  url "https://files.pythonhosted.org/packages/34/8d/9512cf3aa5f93a7fb2ab3f0e6de279df3d2e37deb33c5772b96f89077f26/markdown-up-1.4.10.tar.gz"
  sha256 "05fe52902b8e9a81fe715bd308b6b8d08d11637c3054d268fc93107ff17410b5"
  license "MIT"

  depends_on "python@3.10"

  resource "chisel" do
    url "https://files.pythonhosted.org/packages/6f/47/8121fa65805d654f284655ba2635000ba08c9ff574dbd81318b97cc78af8/chisel-1.2.0.tar.gz"
    sha256 "17365be8acccd4572778ad662aa1e8d43e90574b200113c56586c0cc1b573346"
  end

  resource "schema-markdown" do
    url "https://files.pythonhosted.org/packages/1a/75/2e0b1c14827fb1718e15bf661b83fe3463843b7be46f74456eefe32259e5/schema-markdown-1.2.1.tar.gz"
    sha256 "582bc59b6cdd23cc62608b214d8828997e860a129bb5e1f68ca62d2b082beae2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"markdown-up", "--help"
  end
end
