class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.4.8.tar.gz"
  sha256 "6be0dcb0e3c66c76266944b1c5b6f1d8ba617dc1ce89b8d278f4e1f990a6f70a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1a54f2eb7944c854e4eb59a4ccff80ba7c6cce9c341428a8c3de25940020d1a" => :sierra
    sha256 "b1a54f2eb7944c854e4eb59a4ccff80ba7c6cce9c341428a8c3de25940020d1a" => :el_capitan
    sha256 "b1a54f2eb7944c854e4eb59a4ccff80ba7c6cce9c341428a8c3de25940020d1a" => :yosemite
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
