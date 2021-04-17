class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.17.1/docutils-0.17.1.tar.gz"
  sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "252d181f5b4eb0c502d9a0bf7c70d7ce7e4d52c18f274cc978227ebc223c4ad9"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7e3b4495a340aa0f7c6564d469f10311fc23b0b3e9d78f0d7c241542eee9c28"
    sha256 cellar: :any_skip_relocation, catalina:      "12cab4d54dc321757da38bebd43ab58855902e4fd17c3a163802b5d93f357cce"
    sha256 cellar: :any_skip_relocation, mojave:        "6a66c7b7c241c6057d66df9f5bbf7eb62642d4a3437d207b8b28035bdcc774ce"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
