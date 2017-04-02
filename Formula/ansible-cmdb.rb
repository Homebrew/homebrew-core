class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.21/ansible-cmdb-1.21.zip"
  sha256 "ee7b35803a25c69c8a3d1dd644b701da40567f3d3f2fbc5a782b407308325f1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "20c2907fa46c4e89ae89eb1d63a4cb29a9d4f1cbfc40d7fdd8bc8c147a6ff1c0" => :sierra
    sha256 "20c2907fa46c4e89ae89eb1d63a4cb29a9d4f1cbfc40d7fdd8bc8c147a6ff1c0" => :el_capitan
    sha256 "20c2907fa46c4e89ae89eb1d63a4cb29a9d4f1cbfc40d7fdd8bc8c147a6ff1c0" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  def install
    bin.mkpath
    man1.mkpath
    inreplace "Makefile" do |s|
      s.gsub! "/usr/local/lib/${PROG}", prefix
      s.gsub! "/usr/local/bin", bin
      s.gsub! "/usr/local/share/man/man1", man1
    end
    system "make", "install"
  end

  test do
    system bin/"ansible-cmdb", "-dt", "html_fancy", "."
  end
end
