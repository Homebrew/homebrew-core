class Exim < Formula
  desc "Complete replacement for sendmail"
  homepage "https://exim.org"
  url "https://ftp.exim.org/pub/exim/exim4/exim-4.96.tar.xz"
  sha256 "299a56927b2eb3477daafd3c5bda02bc67e5c4e5898a7aeaf2740875278cf1a3"
  license "GPL-2.0-or-later"
  revision 2

  # Maintenance releases are kept in a `fixes` subdirectory, so it's necessary
  # to check both the main `exim4` directory and the `fixes` subdirectory to
  # identify the latest version.
  livecheck do
    url "https://ftp.exim.org/pub/exim/exim4/"
    regex(/href=.*?exim[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      # Match versions from files in the `exim4` directory
      versions = page.scan(regex).flatten.uniq

      # Return versions if a `fixes` subdirectory isn't present
      next versions if page.match(%r{href=["']?fixes/?["' >]}i).blank?

      # Fetch the page for the `fixes` directory
      fixes_page = Homebrew::Livecheck::Strategy.page_content(URI.join(@url, "fixes").to_s)
      next versions if fixes_page[:content].blank?

      # Match maintenance releases and add them to the versions array
      versions += fixes_page[:content].scan(regex).flatten
      versions
    end
  end

  bottle do
    sha256 arm64_ventura:  "02bbfd3d923e23dd8b9d605ff9f3079b9cbe29150b77c9ee10004c5d4de483ba"
    sha256 arm64_monterey: "1dcfe9e8ff31d30c8c03c2f6db86d29199e3ad3884626e24a202dbf10da5b815"
    sha256 arm64_big_sur:  "9a376535eb48485e2cf30910da5da8fbc422f20790639f643f60195a29ad4bba"
    sha256 ventura:        "7d030fce1ff8c9326ce679d95f07c1ae1ad429e5b54c3363de23e3b207bf25db"
    sha256 monterey:       "8212b900afb9970de0ea5a666d1fdf524d74f638d8233d3edf375ce13668678a"
    sha256 big_sur:        "2380ffa1a08a087a4ccc85c776fabc661cc377f32cd3fba3ebf79d042ae53727"
    sha256 catalina:       "e49195d49265f2e1941c71c39811d92a329ae04b5ea33c34116bdb1c0723307c"
    sha256 x86_64_linux:   "c189cd50a88e4494a00520e2ce63066cea2bcbe8ed3fa1435fcadb73b0d11d29"
  end

  depends_on "berkeley-db@5"
  depends_on "openssl@3"
  depends_on "pcre2"
  uses_from_macos "libxcrypt"

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
    end
    open("Local/Makefile", "a") do |s|
      s << "AUTH_PLAINTEXT=yes\n"
      s << "SUPPORT_TLS=yes\n"
      s << "USE_OPENSSL=yes\n"
      s << "TLS_LIBS=-lssl -lcrypto\n"
      s << "TRANSPORT_LMTP=yes\n"

      # For non-/usr/local HOMEBREW_PREFIX
      s << "LOOKUP_INCLUDE=-I#{HOMEBREW_PREFIX}/include\n"
      s << "LOOKUP_LIBS=-L#{HOMEBREW_PREFIX}/lib\n"
    end

    bdb5 = Formula["berkeley-db@5"]

    cp "OS/unsupported/Makefile-Darwin", "OS/Makefile-Darwin"
    cp "OS/unsupported/os.h-Darwin", "OS/os.h-Darwin"
    inreplace "OS/Makefile-Darwin" do |s|
      s.remove_make_var! %w[CC CFLAGS]
      # Add include and lib paths for BDB 5
      s.gsub! "# Exim: OS-specific make file for Darwin (Mac OS X).", "INCLUDE=-I#{bdb5.include}"
      s.gsub! "DBMLIB =", "DBMLIB=#{bdb5.lib}/libdb-5.dylib"
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
