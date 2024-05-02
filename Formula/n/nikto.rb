class Nikto < Formula
  desc "Web server scanner"
  homepage "https://cirt.net/nikto2"
  url "https://github.com/sullo/nikto/archive/refs/tags/2.5.0.tar.gz"
  sha256 "fb0dc4b2bc92cb31f8069f64ea4d47295bcd11067a7184da955743de7d97709d"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e822edd4d19c031489f940d9f0d3bd37765470baa55519e8c7f0e141f54b8dd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e822edd4d19c031489f940d9f0d3bd37765470baa55519e8c7f0e141f54b8dd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e822edd4d19c031489f940d9f0d3bd37765470baa55519e8c7f0e141f54b8dd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8f31869f1d8481474a9689d80247d222fa9a79a780a3c936be268feab852a16"
    sha256 cellar: :any_skip_relocation, ventura:        "d8f31869f1d8481474a9689d80247d222fa9a79a780a3c936be268feab852a16"
    sha256 cellar: :any_skip_relocation, monterey:       "d8f31869f1d8481474a9689d80247d222fa9a79a780a3c936be268feab852a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e822edd4d19c031489f940d9f0d3bd37765470baa55519e8c7f0e141f54b8dd6"
  end

  def install
    cd "program" do
      inreplace "nikto.pl", "/etc/nikto.conf", "#{etc}/nikto.conf"

      inreplace "nikto.conf.default" do |s|
        s.gsub! "# EXECDIR=/opt/nikto", "EXECDIR=#{prefix}"
        s.gsub! "# PLUGINDIR=/opt/nikto/plugins",
                "PLUGINDIR=#{pkgshare}/plugins"
        s.gsub! "# DBDIR=/opt/nikto/databases",
                "DBDIR=#{var}/lib/nikto/databases"
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
    (var/"lib/nikto/databases").mkpath
    cp_r Dir["program/databases/*"], var/"lib/nikto/databases"
  end

  test do
    system bin/"nikto", "-H"
  end
end
