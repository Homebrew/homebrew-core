class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.5.8.tar.gz"
  sha256 "cb18e95e83c414ab36b125c9aa97c9a79b10a7cba2e94e622242611af5042ffb"

  bottle do
    sha256 "6665bbcb2adfa10cbcd2d09d123bd7c9135ca15dd5f3dac126dd4ed419a63ef1" => :high_sierra
    sha256 "6665bbcb2adfa10cbcd2d09d123bd7c9135ca15dd5f3dac126dd4ed419a63ef1" => :sierra
    sha256 "6665bbcb2adfa10cbcd2d09d123bd7c9135ca15dd5f3dac126dd4ed419a63ef1" => :el_capitan
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
