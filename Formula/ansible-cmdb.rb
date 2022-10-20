class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.31/ansible-cmdb-1.31.tar.gz"
  sha256 "ab1be4a85184647bcec08d4e65bda66c7d08c0f88c81eca4d0e44e02b768c2bb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "39eadb125103aac400189e36112333e6e1da17fb75eae26ec1dd34d99185d798"
  end

  depends_on "libyaml"

  def install
    prefix.install_metafiles
    man1.install "ansible-cmdb.man.1" => "ansible-cmdb.1"
    inreplace "ansible-cmdb.py", "/usr/local", HOMEBREW_PREFIX
    libexec.install Dir["*"] - ["Makefile"]
    bin.write_exec_script libexec/"ansible-cmdb"
  end

  test do
    system bin/"ansible-cmdb", "-dt", "html_fancy", "."
  end
end
