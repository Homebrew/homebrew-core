class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/refs/tags/v1.3.9b.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.9b.tar.gz/"
  version "1.3.9b"
  sha256 "a4dd1820aa70abeac7be234d03a806c3ba1cc86566cf6069d2a14566fc5eb5af"
  license "GPL-2.0-or-later"

  # Proftpd uses an incrementing letter after the numeric version for
  # maintenance releases. Versions like `1.2.3a` and `1.2.3b` are not alpha and
  # beta respectively. Prerelease versions use a format like `1.2.3rc1`.
  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "37c6e346b69d35a6aa282b380c8acbbdb51684e3fe4a970c10074a13fbe1ae36"
    sha256 arm64_sequoia: "33a23e2b750dbf5b3cc2708cfa6c0710a609c0b74496799f68aeba33db8e4cf8"
    sha256 arm64_sonoma:  "29b0ce30fb9d1ea6969cc00d6aa13d1b46f78840986e7536a90c0f9ef9cde662"
    sha256 sonoma:        "2a3b2b3421d10938bffd9a81de3a9ac121b48a709013a296df7ed40c35c347b2"
    sha256 arm64_linux:   "c1867a20cea3ba1b0611c393b126c6c911695c940cfdc5e23177dfd76a4ecec4"
    sha256 x86_64_linux:  "ef4fe579723e5e91923b39d02cc573de70806b1a26f7b0d6f9c9c8d9e94be3c0"
  end

  depends_on "inetutils" => :test

  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gettext"
  end

  def install
    install_user = ENV["USER"]
    install_group = Utils.safe_popen_read("groups").split.first

    # MacOS nobody/nogroup have negative uid/gid which causes errors when running service
    # Linux also blame about uid e.g. unable to set UID to 65534, current UID: 1000
    # So, we replace them with the user and group used for installation
    inreplace "sample-configurations/basic.conf" do |s|
      s.gsub! "nobody", install_user
      s.gsub! "nogroup", install_group
    end

    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{sbin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--enable-nls"
    ENV.deparallelize
    system "make", "all"
    system "make", "INSTALL_USER=#{install_user}", "INSTALL_GROUP=#{install_group}", "install"
  end

  service do
    run [opt_sbin/"proftpd", "--nodaemon"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    assert_match version.to_s, shell_output("#{opt_sbin}/proftpd --version")

    port = free_port
    install_user = ENV["USER"]
    install_group = Utils.safe_popen_read("groups").split.first
    (testpath/"proftpd.conf").write <<~EOS
      ServerName      Homebrew-Test
      ServerType      standalone
      DefaultServer   on
      Port            #{port}
      UseIPv6         off
      Umask           022
      MaxInstances    3
      User            #{install_user}
      Group           #{install_group}
      ScoreboardFile  #{testpath}/proftpd.scoreboard
      PidFile         #{testpath}/proftpd.pid
    EOS

    pid = spawn sbin/"proftpd", "--config", testpath/"proftpd.conf", "--nodaemon"
    sleep 2
    output = pipe_output(
      "#{Formula["inetutils"].opt_bin}/ftp --no-login --no-prompt --verbose",
      "open 127.0.0.1 #{port}\nuser anonymous anonymous\nquit\n",
      0,
    )
    assert_match "Connected to 127.0.0.1.\n220 ProFTPD Server (Homebrew-Test)", output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
