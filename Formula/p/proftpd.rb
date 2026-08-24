class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/refs/tags/v1.3.9d.tar.gz"
  version "1.3.9d"
  sha256 "68b094b1c57c775ad00ef469e9a87783dbbf31a85f98f48faf60becc2e84e4ec"
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
    sha256 arm64_tahoe:   "b8ea38cc378fe88efacdfc5d60bfd464688f8786998c46346da80dc9ab79f2db"
    sha256 arm64_sequoia: "c9f09a9d1f4b9a8bc19232184e06cef8c2168aa46fd7141aa2984aa4db7293ac"
    sha256 arm64_sonoma:  "2b154e2f05adc0f926d2c55d4e801858240f311159190e7bf43a705907642de3"
    sha256 sonoma:        "83270a21221a36d2e9d07e17268f3bef06e0dec27c4c07ca064ad13707777935"
    sha256 arm64_linux:   "74ec79dd63a01e2efc723e881750fe275eaab901a68f369005f097756f192e31"
    sha256 x86_64_linux:  "4e4593fe9bc9e4f0481b7934416feafd2f23295877e2827f5c85d959ca487719"
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

    system "./configure", "--enable-nls",
                          "--sbindir=#{sbin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
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
    (testpath/"proftpd.conf").write <<~CONF
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
    CONF

    pid = spawn sbin/"proftpd", "--config", testpath/"proftpd.conf", "--nodaemon"
    sleep 2
    output = pipe_output(
      "#{formula_opt_bin("inetutils")}/ftp --no-login --no-prompt --verbose",
      "open 127.0.0.1 #{port}\nuser anonymous anonymous\nquit\n",
      0,
    )
    assert_match "Connected to 127.0.0.1.\n220 ProFTPD Server (Homebrew-Test)", output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
