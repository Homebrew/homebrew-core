class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.5.5.tar.gz"
  sha256 "638c587396fbd2e857d6a3d2229db3b071704c0e217e03055c9268b495ab8102"

  bottle do
    cellar :any_skip_relocation
    sha256 "96c4ea6e45d3861b8e9f83d2456a0de62b0781210472fb99d2bb1f9a2000976d" => :high_sierra
    sha256 "8b44b18ac549e519dd9645f0a8669298b3fbb78ece444d49a02e509890ba5bc5" => :sierra
    sha256 "8b44b18ac549e519dd9645f0a8669298b3fbb78ece444d49a02e509890ba5bc5" => :el_capitan
    sha256 "8b44b18ac549e519dd9645f0a8669298b3fbb78ece444d49a02e509890ba5bc5" => :yosemite
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
