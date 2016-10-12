class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.17/ansible-cmdb-1.17.zip"
  sha256 "e0867475a0cf4f7579b8e0cd2cd81ac0c5a168e5f25cc3ff9c5f5c56d5a8f157"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bc94295d6933dc6e5eed2215612b4cc5440b08bb37ff3242fbeddf6eef5774e" => :sierra
    sha256 "4bc94295d6933dc6e5eed2215612b4cc5440b08bb37ff3242fbeddf6eef5774e" => :el_capitan
    sha256 "4bc94295d6933dc6e5eed2215612b4cc5440b08bb37ff3242fbeddf6eef5774e" => :yosemite
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
