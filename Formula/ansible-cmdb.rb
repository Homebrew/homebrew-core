class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.24/ansible-cmdb-1.24.zip"
  sha256 "b497e381f3be3f9a56d6f4e93d3e9ff093dc7a585dc78ed126ced0d1c3b180f9"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard
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
