class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.29/ansible-cmdb-1.29.tar.gz"
  sha256 "13e4cedca66dd3eb4f3b0ac0c7415b1d8e9648dbc919147a75c8aa557fd1c690"

  bottle :unneeded

  depends_on "libyaml"

  def install
    prefix.install_metafiles
    man1.install "ansible-cmdb.man.1" => "ansible-cmdb.1"
    libexec.install Dir["*"] - ["Makefile"]
    bin.write_exec_script libexec/"ansible-cmdb"
  end

  test do
    system bin/"ansible-cmdb", "-dt", "html_fancy", "."
  end
end
