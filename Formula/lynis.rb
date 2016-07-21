class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.3.1.tar.gz"
  sha256 "7657ee66f81f72504c70a3a321f4fe87ddb5754f32e6a3c4234fd38a5c23c28c"

  bottle do
    cellar :any_skip_relocation
    sha256 "843e6038c9637cc3f39a52d1c7475c0a751d0c7f4699b810fe09f63c79eaba43" => :el_capitan
    sha256 "704a1577a690667e11b78de4181c6308e736ef1dd1439f54d8c9ea7bce27d39f" => :yosemite
    sha256 "6b0b745d65629fcfd969f7c476b0ccb98255344aa303edca93a8e2a42029aeed" => :mavericks
  end

  def install
    inreplace "lynis" do |s|
      s.gsub! 'tINCLUDE_TARGETS="/usr/local/include/lynis /usr/local/lynis/include /usr/share/lynis/include ./include"',
        %(tINCLUDE_TARGETS="#{include}")
      s.gsub! 'tPLUGIN_TARGETS="/usr/local/lynis/plugins /usr/local/share/lynis/plugins /usr/share/lynis/plugins /etc/lynis/plugins ./plugins"',
        %(tPLUGIN_TARGETS="#{prefix}/plugins")
      s.gsub! 'tDB_TARGETS="/usr/local/share/lynis/db /usr/local/lynis/db /usr/share/lynis/db ./db"',
        %(tDB_TARGETS="#{prefix}/db")
    end
    inreplace "include/functions" do |s|
      s.gsub! 'tPROFILE_TARGETS="/usr/local/etc/lynis /etc/lynis /usr/local/lynis ."',
        %(tPROFILE_TARGETS="#{prefix}")
    end

    prefix.install "db", "include", "plugins", "default.prf"
    bin.install "lynis"
    man8.install "lynis.8"
  end

 test do
    # has return code 1 when finding invalid option
    assert_match "lynis", shell_output("#{bin}/lynis --invalid 2>&1", 64)
  end
end
