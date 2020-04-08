class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.16/docutils-0.16.tar.gz"
  sha256 "7d4e999cca74a52611773a42912088078363a30912e8822f7a3d38043b767573"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0ef5a1355a1eeb6d30a19ed818494363151bc05446dddeffed214c8d80e85832" => :catalina
    sha256 "7d1bae12504b75f88a4a3ffe205aafb06ea2666266f8840089fff922b12288bc" => :mojave
    sha256 "d81d6ad3f2d55b2e77639610b1865571decddf42b4f5f73de02edadc9b8b11df" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
