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
    sha256 arm64_monterey: "bfcc18b3b112229974b9f9839b96058b874f63a7bbfc21ac4bef043eeb5850ca"
    sha256 arm64_big_sur:  "41890d699c864032ea29741455a7617eab29c7bd89b2fe467fd7caeff9287c87"
    sha256 monterey:       "b0fa89cb8c9dc1366d979062e5826b291dfffde56f51ff46104bb06ebafb117c"
    sha256 big_sur:        "2364baa048a883702e87bf86a00c6f3d8e66907e9d6d58c057ab4af55adf5997"
    sha256 catalina:       "44335942f74790d3af88bbaf4052cf625ef9a7890dadfa85fd9e1c9f277442b1"
    sha256 x86_64_linux:   "4cc61804dd1275dc4091d762ff3aa95c545852089a2b0eefafe597f5e778ed01"
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
