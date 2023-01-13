class Automysqlbackup < Formula
  desc "Automate MySQL backups"
  homepage "https://sourceforge.net/projects/automysqlbackup/"
  url "https://downloads.sourceforge.net/project/automysqlbackup/AutoMySQLBackup/AutoMySQLBackup%20VER%203.0/automysqlbackup-v3.0_rc6.tar.gz"
  version "3.0-rc6"
  sha256 "889e064d086b077e213da11e937ea7242a289f9217652b9051c157830dc23cc0"

  livecheck do
    url :stable
    regex(%r{url=.*?/automysqlbackup[._-]v?(\d+(?:\.\d+)+(?:[._-]?rc\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bbb9737e441d517ac533d4d1cf3ecf6c5dcbd6bfb255dbc4d3d8c6763f41627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a6221b7df024f5ba0ab971d2f00a6f788aa7ba4c4fa5409556a6540de0f7afd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6499ee140c9ecc7517483b77dd3cdbd9b810c78ccd669e4160b13743d947be33"
    sha256 cellar: :any_skip_relocation, ventura:        "7e67a4cee792d773a70aa60b184432028d2e7f551c785b926d7e061d4c98878f"
    sha256 cellar: :any_skip_relocation, monterey:       "005eed57e1d895c9afb736b8931e05d4960bdfc4c50faff45094db816aecb65c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6ce3e08b162183d802d0f2e58df6c485b8b53ef1354947f506e4bde4b53dc40"
    sha256 cellar: :any_skip_relocation, catalina:       "d6ce3e08b162183d802d0f2e58df6c485b8b53ef1354947f506e4bde4b53dc40"
    sha256 cellar: :any_skip_relocation, mojave:         "d6ce3e08b162183d802d0f2e58df6c485b8b53ef1354947f506e4bde4b53dc40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6499ee140c9ecc7517483b77dd3cdbd9b810c78ccd669e4160b13743d947be33"
  end

  def install
    inreplace "automysqlbackup" do |s|
      s.gsub! "/etc", etc
      s.gsub! "/var", var
    end
    inreplace "automysqlbackup.conf", "/var", var

    conf_path = (etc/"automysqlbackup")
    conf_path.install "automysqlbackup.conf" unless (conf_path/"automysqlbackup.conf").exist?
    sbin.install "automysqlbackup"
  end

  def caveats
    <<~EOS
      You will have to edit
        #{etc}/automysqlbackup/automysqlbackup.conf
      to set AutoMySQLBackup up to find your database and backup directory.

      The included service will run AutoMySQLBackup every day at 04:00.
    EOS
  end

  service do
    run opt_sbin/"automysqlbackup"
    working_dir HOMEBREW_PREFIX
    run_type :cron
    cron "0 4 * * *"
    log_path var/"log/automysqlbackup.log"
    error_log_path var/"log/automysqlbackup.log"
  end

  test do
    system "#{sbin}/automysqlbackup", "--help"
  end
end
