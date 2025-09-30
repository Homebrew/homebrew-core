class Automysqlbackup < Formula
  desc "Automate MySQL backups"
  homepage "https://sourceforge.net/projects/automysqlbackup/"
  url "https://downloads.sourceforge.net/project/automysqlbackup/AutoMySQLBackup/AutoMySQLBackup%20VER%203.0/automysqlbackup-v3.0_rc6.tar.gz"
  version "3.0-rc6"
  sha256 "889e064d086b077e213da11e937ea7242a289f9217652b9051c157830dc23cc0"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/automysqlbackup[._-]v?(\d+(?:\.\d+)+(?:[._-]?rc\d+)?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47848e3272f89cc4d30787693b27799507fe8d7593d51b2586431e88eb92c6dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eae5fa097a6796bd0aeb27e2a4026257d8b8a868263f292a693723c32404a0d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eae5fa097a6796bd0aeb27e2a4026257d8b8a868263f292a693723c32404a0d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eae5fa097a6796bd0aeb27e2a4026257d8b8a868263f292a693723c32404a0d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c34d3e9363096874a38e300b7ca801587d5e3076de4fd0b9504229b3544cfb50"
    sha256 cellar: :any_skip_relocation, ventura:       "c34d3e9363096874a38e300b7ca801587d5e3076de4fd0b9504229b3544cfb50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eae5fa097a6796bd0aeb27e2a4026257d8b8a868263f292a693723c32404a0d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eae5fa097a6796bd0aeb27e2a4026257d8b8a868263f292a693723c32404a0d3"
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
