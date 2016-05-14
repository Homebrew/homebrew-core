class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.14/ansible-cmdb-1.14.zip"
  sha256 "7c787ca6473ce1b4c686438bff6c952ef8bfd725e9a78582eab54edf5fbdf6f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "23fa2a32d2d8da2b922a565a7c093782c4fea29d6066015af9f1f0802c216707" => :el_capitan
    sha256 "691be204497994bc77895b81a1985aeaf633ced0820af7866f70cf287d1a4de9" => :yosemite
    sha256 "dbcb663956cf96e6ab49fba865cafac24a559f714ee2d66a9b083ed28de40cba" => :mavericks
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
    (testpath/"hosts").write <<-EOS.undent
[brew_test]
brew1   dtap=dev  comment='Old database server'
brew2   dtap=dev  comment='New database server'
      EOS
    system "#{bin}/ansible-cmdb", "-dt", "html_fancy", "."
  end
end
