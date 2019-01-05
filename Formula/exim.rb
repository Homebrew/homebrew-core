class Exim < Formula
  desc "Complete replacement for sendmail"
  homepage "https://exim.org"
  url "https://ftp.exim.org/pub/exim/exim4/exim-4.91.tar.xz"
  sha256 "ec57acb103d5550aca8d60adb57f355c7b3c41b5449290594ed6615ad4b9d118"

  bottle do
    sha256 "202cd9263540aba1947b9095c5ecf3b91e28fa6da2e5f2f0e58cf63e2c8f4770" => :mojave
    sha256 "29d984d5bfd7b421c4f8a4aa93155e8ccbc324fa781f0edf5001a90f2996f0dc" => :high_sierra
    sha256 "078199c3db96e3ca5ffdaac9c6421c67a704814afeb741c0014a457c58bd1a5d" => :sierra
    sha256 "df47c95efa6bcfe75fb26898845b341be2d9fbc26e1f0ba82d12dc6463ffbcaf" => :el_capitan
  end

  depends_on "berkeley-db@4"
  depends_on "openssl"
  depends_on "pcre"

  def install
    cp "src/EDITME", "Local/Makefile"
    inreplace "Local/Makefile" do |s|
      s.remove_make_var! "EXIM_MONITOR"
      s.change_make_var! "EXIM_USER", ENV["USER"]
      s.change_make_var! "SYSTEM_ALIASES_FILE", etc/"aliases"
      s.gsub! "/usr/exim/configure", etc/"exim.conf"
      s.gsub! "/usr/exim", prefix
      s.gsub! "/var/spool/exim", var/"spool/exim"
      # https://trac.macports.org/ticket/38654
      s.gsub! 'TMPDIR="/tmp"', "TMPDIR=/tmp"
      s << "AUTH_PLAINTEXT=yes\n"
      s << "SUPPORT_TLS=yes\n"
      s << "TLS_LIBS=-lssl -lcrypto\n"
      s << "TRANSPORT_LMTP=yes\n"

      # For non-/usr/local HOMEBREW_PREFIX
      s << "LOOKUP_INCLUDE=-I#{HOMEBREW_PREFIX}/include\n"
      s << "LOOKUP_LIBS=-L#{HOMEBREW_PREFIX}/lib\n"
    end

    bdb4 = Formula["berkeley-db@4"]

    mv Dir["OS/unsupported/*Darwin*"], "OS"

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
  def startup_script; <<~EOS
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

  def caveats; <<~EOS
    Start with:
      exim_ctl start
    Don't forget to run it as root to be able to bind port 25.
  EOS
  end

  test do
    assert_match "Mail Transfer Agent", shell_output("#{bin}/exim --help 2>&1", 1)
  end
end
