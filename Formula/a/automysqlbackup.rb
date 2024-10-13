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

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d86303f7b195098a8025ee17b9fb0abd0c0b347c69cef3189a927df01d1145d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dff492b004afd5fd0c2f20991204c99c872a810a10fbaf47ac6c09dbde611a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "452812b8437cd65781adbe94558e474283d72ba8a883250a4d141c4e8c284f8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "452812b8437cd65781adbe94558e474283d72ba8a883250a4d141c4e8c284f8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "452812b8437cd65781adbe94558e474283d72ba8a883250a4d141c4e8c284f8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "43d1f5181c2f11161be09dbcfcf7e25c91e5f79074f232906822354215b1ca5c"
    sha256 cellar: :any_skip_relocation, ventura:        "97797f99e2b639017bf9dc545b3beaefcf22276a8fad76785afc96674813dcb1"
    sha256 cellar: :any_skip_relocation, monterey:       "97797f99e2b639017bf9dc545b3beaefcf22276a8fad76785afc96674813dcb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "97797f99e2b639017bf9dc545b3beaefcf22276a8fad76785afc96674813dcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "452812b8437cd65781adbe94558e474283d72ba8a883250a4d141c4e8c284f8c"
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
