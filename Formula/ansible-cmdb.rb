class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.23/ansible-cmdb-1.23.zip"
  sha256 "a8ee66ba4bc203b9b0b75bac311131292e6b7291ac85e79b5e2d5f079cd3fb3f"

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
