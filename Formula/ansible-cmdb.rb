class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.21/ansible-cmdb-1.21.zip"
  sha256 "ee7b35803a25c69c8a3d1dd644b701da40567f3d3f2fbc5a782b407308325f1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ca754d561e02b3d75fb6b21e94e032cab3d7830ed997990a215287ac0da1b3a" => :sierra
    sha256 "8ca754d561e02b3d75fb6b21e94e032cab3d7830ed997990a215287ac0da1b3a" => :el_capitan
    sha256 "8ca754d561e02b3d75fb6b21e94e032cab3d7830ed997990a215287ac0da1b3a" => :yosemite
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
