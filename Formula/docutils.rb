class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.16/docutils-0.16.tar.gz"
  sha256 "7d4e999cca74a52611773a42912088078363a30912e8822f7a3d38043b767573"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ed4972eaa10a0be627db7bc83f75f7537b1a6b3507bb7b3331ffa6afcfcc8f44" => :catalina
    sha256 "ad73ff1ad1ea76399afbf1b988d956837dd9864eb287e8356760b2929d8cd875" => :mojave
    sha256 "549d758b772b99e1f231b5c1e661f4a661dbcd5eb81092de92fad8f2b1f76a2c" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
