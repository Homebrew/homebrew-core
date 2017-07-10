class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.22/ansible-cmdb-1.22.zip"
  sha256 "c012d46a0f782d7443c6b230194d5afde1e3f72915869a43b119304800c916fc"

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
