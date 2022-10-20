class Nikto < Formula
  desc "Web server scanner"
  homepage "https://cirt.net/nikto2"
  url "https://github.com/sullo/nikto/archive/2.1.6.tar.gz"
  sha256 "c1731ae4133d3879718bb7605a8d395b2036668505effbcbbcaa4dae4e9f27f2"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb11bfbc15cae557394eb54a4edf5ad658b32af5b2085b92089f25104894a87c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb11bfbc15cae557394eb54a4edf5ad658b32af5b2085b92089f25104894a87c"
    sha256 cellar: :any_skip_relocation, monterey:       "a664c33768310d6673ef4a4adc9fa11522abd974f44928f7635b5663b11f948e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a664c33768310d6673ef4a4adc9fa11522abd974f44928f7635b5663b11f948e"
    sha256 cellar: :any_skip_relocation, catalina:       "a664c33768310d6673ef4a4adc9fa11522abd974f44928f7635b5663b11f948e"
    sha256 cellar: :any_skip_relocation, mojave:         "a664c33768310d6673ef4a4adc9fa11522abd974f44928f7635b5663b11f948e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb11bfbc15cae557394eb54a4edf5ad658b32af5b2085b92089f25104894a87c"
  end

  def install
    cd "program" do
      inreplace "nikto.pl", "/etc/nikto.conf", "#{etc}/nikto.conf"

      inreplace "nikto.conf" do |s|
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
      etc.install "nikto.conf"
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
