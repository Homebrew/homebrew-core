class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.16/docutils-0.16.tar.gz"
  sha256 "7d4e999cca74a52611773a42912088078363a30912e8822f7a3d38043b767573"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b29e292e287170881f5e88d0e05fa41420515081126e486332d9036c8024f9ef" => :catalina
    sha256 "8fe38011ae417e9f2476fdadc5a3c96558fa4f6ce7c86ac3961a71b9b35ecfbc" => :mojave
    sha256 "771eee4e347d10e5e9722e2c74f99c31e4c712aa06d422bd1c03903b2bba7b97" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
