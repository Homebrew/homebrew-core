class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.13.1/docutils-0.13.1.tar.gz"
  sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "cae7b82e3555eacdd6156c67af59a71d03274b006857ddbc84fe639136b21902" => :sierra
    sha256 "1a7d2c671cbd6f88c81de7c2abf2cc099794313b082c81ae8079b86d40ad3cd2" => :el_capitan
    sha256 "1a7d2c671cbd6f88c81de7c2abf2cc099794313b082c81ae8079b86d40ad3cd2" => :yosemite
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
