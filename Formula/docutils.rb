class Docutils < Formula
  desc "Text processing system for reStructuredText"
  homepage "http://docutils.sourceforge.net"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.13.1/docutils-0.13.1.tar.gz"
  sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"

  bottle do
    cellar :any_skip_relocation
    sha256 "cae7b82e3555eacdd6156c67af59a71d03274b006857ddbc84fe639136b21902" => :sierra
    sha256 "1a7d2c671cbd6f88c81de7c2abf2cc099794313b082c81ae8079b86d40ad3cd2" => :el_capitan
    sha256 "1a7d2c671cbd6f88c81de7c2abf2cc099794313b082c81ae8079b86d40ad3cd2" => :yosemite
    sha256 "622c6bfe613641ae3d5d3a0ddad3e000fb18a779548be22f532a00bece9ef7c6" => :x86_64_linux
  end

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    ENV.prepend_create_path "PYTHONPATH", HOMEBREW_PREFIX/"lib/python2.7/site-packages" unless OS.mac?
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
