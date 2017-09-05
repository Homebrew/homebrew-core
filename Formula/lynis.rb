class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.5.4.tar.gz"
  sha256 "08a66ea06f9a96c8659495be7d7d9530dc34ea679d377efd761307162f895716"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6d00b56462f1d0549e2baaf610aaee736268a96036bd52c66907343d99bb3fc" => :sierra
    sha256 "a6d00b56462f1d0549e2baaf610aaee736268a96036bd52c66907343d99bb3fc" => :el_capitan
    sha256 "a6d00b56462f1d0549e2baaf610aaee736268a96036bd52c66907343d99bb3fc" => :yosemite
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
