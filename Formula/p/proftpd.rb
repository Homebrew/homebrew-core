class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/refs/tags/v1.3.9a.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.9a.tar.gz/"
  version "1.3.9a"
  sha256 "bc3c7c47033ecff29f010efc18315d5906eb942d2e673ebce0138a96f11af0b4"
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
    sha256 arm64_tahoe:   "519b3e107f26dff195d5f197948afb13f5fcf38d9df3a0f15e066fea811c2cd3"
    sha256 arm64_sequoia: "d3152963fc939b0ec0b3e00eee27b803d27d641d54c99c931cce0900b0a35600"
    sha256 arm64_sonoma:  "45a29db791dccd0f57c8ca0184a7c2ff9733ac37b496361a82017ec6154534d0"
    sha256 sonoma:        "14da5d0600ba2e85d84c223278e5d0a2951ab62b4be2b4836a0eeeffe2828bb0"
    sha256 arm64_linux:   "13dbf7d1c37a5edd413f5b3062b026304eb8549f977425eb73c677bfd1f380e1"
    sha256 x86_64_linux:  "7270bfceb1857dd1c0f2d3b2626325dc5ca56eab461c176a5bd85800fd654355"
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
