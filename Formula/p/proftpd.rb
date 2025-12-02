class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/refs/tags/v1.3.9.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.9.tar.gz/"
  sha256 "4a5f13b666226813b4da0ade34535d325e204ab16cf8008c7353b1b5a972f74b"
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
    rebuild 1
    sha256 arm64_tahoe:   "0403d12abcf2e2503d5a0cb195188de6ad4f9276d99b7f80b39da7c5fc815ccf"
    sha256 arm64_sequoia: "4e369912c18c4ea78435f13a74ce45180e656d04290f20ff398443de3a68ee9b"
    sha256 arm64_sonoma:  "12eff8d0547d82048f227c50da34717e7595a7a07ac784ae5c2978ce676b0328"
    sha256 sonoma:        "294004644b0e2d4799b1e4753c2ef6cc44a93001b017a7d177be890cf79a647a"
    sha256 arm64_linux:   "8d1a0954158c3c5fad4e736cf9ddb60802cf8e1fe8317d70ea3ba766b3ba2c30"
    sha256 x86_64_linux:  "cf38eeacafb8c58b2a3e5e1bc2fb67426dfe0f65ce7d13d037edacd41f834f3e"
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
