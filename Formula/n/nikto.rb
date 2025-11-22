class Nikto < Formula
  desc "Web server scanner"
  homepage "https://cirt.net/nikto/"
  url "https://github.com/sullo/nikto/archive/refs/tags/2.5.0.tar.gz"
  sha256 "fb0dc4b2bc92cb31f8069f64ea4d47295bcd11067a7184da955743de7d97709d"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ab8f5f0295ab3a4599a11e2cb63486c8da93c91c0088bc6f29307db3aec3df58"
  end

  def install
    cd "program" do
      inreplace "nikto.pl", "/etc/nikto.conf", "#{etc}/nikto.conf"

      inreplace "nikto.conf.default" do |s|
        s.gsub! "# EXECDIR=/opt/nikto", "EXECDIR=#{prefix}"
        s.gsub! "# PLUGINDIR=/opt/nikto/plugins",
                "PLUGINDIR=#{pkgshare}/plugins"
        s.gsub! "# DBDIR=/opt/nikto/databases",
                "DBDIR=#{var}/nikto/databases"
        s.gsub! "# TEMPLATEDIR=/opt/nikto/templates",
                "TEMPLATEDIR=#{pkgshare}/templates"
        s.gsub! "# DOCDIR=/opt/nikto/docs", "DOCDIR=#{pkgshare}/docs"
      end

      bin.install "nikto.pl" => "nikto"
      bin.install "replay.pl"
      etc.install "nikto.conf.default" => "nikto.conf"
      man1.install "docs/nikto.1"
      pkgshare.install "docs", "plugins", "templates"
    end

    doc.install Dir["documentation/*"]
    (var/"nikto/databases").mkpath
    cp_r Dir["program/databases/*"], var/"nikto/databases"
  end

  test do
    system bin/"nikto", "-H"
  end
end
