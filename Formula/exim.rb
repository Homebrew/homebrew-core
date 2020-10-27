class Exim < Formula
  desc "Complete replacement for sendmail"
  homepage "https://exim.org"
  url "https://ftp.exim.org/pub/exim/exim4/exim-4.94.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/exim-4.94.tar.xz"
  sha256 "f77ee8faf04f5db793243c3ae81c1f4e452cd6ad7dd515a80edf755c4b144bdb"
  license "GPL-2.0"

  # The upstream download page at https://ftp.exim.org/pub/exim/exim4/ places
  # maintenance releases (e.g., 4.93.0.4) in a separate "fixes" subdirectory.
  # As a result, we can't create a check that finds both the main releases
  # (e.g., 4.93) and the aforementioned maintenance releases. The Git repo tags
  # seem to be the best solution currently and we're using the GitHub mirror
  # below since the upstream repo (git://git.exim.org/exim.git) doesn't work
  # over https.
  livecheck do
    url "https://github.com/Exim/exim.git"
    regex(/^exim[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "74e195304b29ce8ce47fbccc2c58e468a677482a94efecc1cfd9dcc0210c07d1" => :catalina
    sha256 "bae912aa71182fd91e5e65b38cba3ea162f7d63d4dc4b4b365ef6532c4329a7a" => :mojave
    sha256 "230f63be05a2dde5fcb4487e7159db758abe984cbc70d495a697c209107fc284" => :high_sierra
  end

  depends_on "berkeley-db@4"
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    cp "src/EDITME", "Local/Makefile"
    inreplace "Local/Makefile" do |s|
      s.change_make_var! "EXIM_USER", ENV["USER"]
      s.change_make_var! "SYSTEM_ALIASES_FILE", etc/"aliases"
      s.gsub! "/usr/exim/configure", etc/"exim.conf"
      s.gsub! "/usr/exim", prefix
      s.gsub! "/var/spool/exim", var/"spool/exim"
      # https://trac.macports.org/ticket/38654
      s.gsub! 'TMPDIR="/tmp"', "TMPDIR=/tmp"
      s << "AUTH_PLAINTEXT=yes\n"
      s << "SUPPORT_TLS=yes\n"
      s << "USE_OPENSSL=yes\n"
      s << "TLS_LIBS=-lssl -lcrypto\n"
      s << "TRANSPORT_LMTP=yes\n"

      # For non-/usr/local HOMEBREW_PREFIX
      s << "LOOKUP_INCLUDE=-I#{HOMEBREW_PREFIX}/include\n"
      s << "LOOKUP_LIBS=-L#{HOMEBREW_PREFIX}/lib\n"
    end

    bdb4 = Formula["berkeley-db@4"]

    inreplace "OS/Makefile-Darwin" do |s|
      s.remove_make_var! %w[CC CFLAGS]
      # Add include and lib paths for BDB 4
      s.gsub! "# Exim: OS-specific make file for Darwin (Mac OS X).", "INCLUDE=-I#{bdb4.include}"
      s.gsub! "DBMLIB =", "DBMLIB=#{bdb4.lib}/libdb-4.dylib"
    end

    # The compile script ignores CPPFLAGS
    ENV.append "CFLAGS", ENV.cppflags

    ENV.deparallelize # See: https://lists.exim.org/lurker/thread/20111109.083524.87c96d9b.en.html
    system "make"
    system "make", "INSTALL_ARG=-no_chown", "install"
    man8.install "doc/exim.8"
    (bin/"exim_ctl").write startup_script
  end

  # Inspired by MacPorts startup script. Fixes restart issue due to missing setuid.
  def startup_script
    <<~EOS
      #!/bin/sh
      PID=#{var}/spool/exim/exim-daemon.pid
      case "$1" in
      start)
        echo "starting exim mail transfer agent"
        #{bin}/exim -bd -q30m
        ;;
      restart)
        echo "restarting exim mail transfer agent"
        /bin/kill -15 `/bin/cat $PID` && sleep 1 && #{bin}/exim -bd -q30m
        ;;
      stop)
        echo "stopping exim mail transfer agent"
        /bin/kill -15 `/bin/cat $PID`
        ;;
      *)
        echo "Usage: #{bin}/exim_ctl {start|stop|restart}"
        exit 1
        ;;
      esac
    EOS
  end

  def caveats
    <<~EOS
      Start with:
        exim_ctl start
      Don't forget to run it as root to be able to bind port 25.
    EOS
  end

  test do
    assert_match "Mail Transfer Agent", shell_output("#{bin}/exim --help 2>&1", 1)
  end
end
