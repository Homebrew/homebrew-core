class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.3.1.tar.gz"
  sha256 "7657ee66f81f72504c70a3a321f4fe87ddb5754f32e6a3c4234fd38a5c23c28c"

  bottle do
    cellar :any_skip_relocation
    sha256 "de6b7c06c57e8983fbce64418beacbbf1c64c698ecf1d82d8370cc2b4a043383" => :sierra
    sha256 "f11621d247bfc4fa9571ee78081f7111ff9ea33d80c63a35e5bbea15cdae3668" => :el_capitan
    sha256 "dfa06ae915df07c88e10f57061a528e02abfdc82d5ea5559f3965e8fc6d18435" => :yosemite
    sha256 "2ddc163d0dc97885bb863cd373eeefb2d053d3a4700a6b980bd515cb561f5083" => :mavericks
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
    assert_match "lynis", shell_output("#{bin}/lynis --invalid 2>&1", 64)
  end
end
