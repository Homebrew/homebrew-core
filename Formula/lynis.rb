class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.4.6.tar.gz"
  sha256 "55403a5baea674a412655e8504c2778c4ada5df6d60dc464e462bc8b97b93c8b"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d504a9d87afd2ed11d53ba3ce26dc603f7017333c9ab2100bda5f26ad99ce9b" => :sierra
    sha256 "0d504a9d87afd2ed11d53ba3ce26dc603f7017333c9ab2100bda5f26ad99ce9b" => :el_capitan
    sha256 "0d504a9d87afd2ed11d53ba3ce26dc603f7017333c9ab2100bda5f26ad99ce9b" => :yosemite
  end

  def install
    inreplace "lynis" do |s|
      s.gsub! 'tINCLUDE_TARGETS="/usr/local/include/lynis /usr/local/lynis/include /usr/share/lynis/include ./include"',
        %Q(tINCLUDE_TARGETS="#{include}")
      s.gsub! 'tPLUGIN_TARGETS="/usr/local/lynis/plugins /usr/local/share/lynis/plugins /usr/share/lynis/plugins /etc/lynis/plugins ./plugins"',
        %Q(tPLUGIN_TARGETS="#{prefix}/plugins")
      s.gsub! 'tDB_TARGETS="/usr/local/share/lynis/db /usr/local/lynis/db /usr/share/lynis/db ./db"',
        %Q(tDB_TARGETS="#{prefix}/db")
    end
    inreplace "include/functions" do |s|
      s.gsub! 'tPROFILE_TARGETS="/usr/local/etc/lynis /etc/lynis /usr/local/lynis ."',
        %Q(tPROFILE_TARGETS="#{prefix}")
    end

    prefix.install "db", "include", "plugins", "default.prf"
    bin.install "lynis"
    man8.install "lynis.8"
  end

  test do
    assert_match "lynis", shell_output("#{bin}/lynis --invalid 2>&1", 64)
  end
end
