class Gitgen < Formula

  include Language::Python::Virtualenv

  desc "A CLI tool for generating git commits to boost your GitHub activity"
  homepage "https://pypi.org/project/gitgen/"
  url "https://github.com/mubashardev/gitgen/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "291061dc02dc96ee0c706ec6bc573f10b0d39419b3b30c1ce4444ea5d2ebbb0b"
  license "MIT"
  revision 1
  version "0.1.3"
  depends_on "python@3.9"

# Installs the formula using virtualenv_install_with_resources.
  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/gitgen", "--version"
  end
end