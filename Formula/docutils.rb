class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.14/docutils-0.14.tar.gz"
  sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"

  bottle do
    cellar :any_skip_relocation
    sha256 "c48f799c313e8c8008ced95c907c902284c289e7f1212ef96d8770f28dd56a01" => :sierra
    sha256 "823debb7f2b27abbd6e4deb33bcc6cf322c2f79d4b976262b852d95fad36c3dd" => :el_capitan
    sha256 "53e168f1335e9198d4948b2d89c434097b8878c835efeb2c6f0f116353212702" => :yosemite
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
