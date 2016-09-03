class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.16/ansible-cmdb-1.16.zip"
  sha256 "4839b19577ffc07b2d47cc8a73ef82ead28836a575cb2293042171041fe1c96c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2b001c49879c6cb8efffdaeabf80d530c5b66d4bd188feaeba1cf05003f5f6b" => :el_capitan
    sha256 "23aef8682e8dbb5277df2c32eb0a2538ce5ea1bbc6ecbe84feca050a03e78fbe" => :yosemite
    sha256 "a24c9752029f2397983a739b8dd6c3a1f7f7aff05131c9cbb869ef37dcf4117b" => :mavericks
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
