class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.15/ansible-cmdb-1.15.zip"
  sha256 "9f64a29b0bca69d0cc31ef4b89267a37a3d41186ceaaf29a2d88970e45596044"

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
    system bin/"ansible-cmdb", "-dt", "html_fancy", "."
  end
end
