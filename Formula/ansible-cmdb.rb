class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.20/ansible-cmdb-1.20.zip"
  sha256 "0ad8ead2ae4b7f34841ea47f8632bd58463739dbae6587ed8c77c0c043109dd4"

  bottle do
    cellar :any_skip_relocation
    sha256 "aad50fc48b63ae7f86e7ee31caa6ec7bb2355c6db1d15328e062cd4d67baf30b" => :sierra
    sha256 "e082648bf95663387b914a5b260c110b0ca805ccff0203befb146eff39165aed" => :el_capitan
    sha256 "e082648bf95663387b914a5b260c110b0ca805ccff0203befb146eff39165aed" => :yosemite
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
