class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.15/ansible-cmdb-1.15.zip"
  sha256 "9f64a29b0bca69d0cc31ef4b89267a37a3d41186ceaaf29a2d88970e45596044"

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
