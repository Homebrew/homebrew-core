class Exim < Formula
  desc "Complete replacement for sendmail"
  homepage "https://exim.org"
  url "https://ftp.exim.org/pub/exim/exim4/exim-4.95.tar.xz"
  sha256 "cc9cb653fff2ea947c3702680b59c99ac0bd1bbf19976d37e22a463cd804f167"
  license "GPL-2.0-or-later"

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
    sha256 arm64_monterey: "52c643ce9c129aff859aabfb48764f73c48a6aafc1172e419f8736e6c5a736a1"
    sha256 arm64_big_sur:  "c47a9b199a7c8d21242cc6155b96845d7da106d724a7f164e3e39a5eb9b919ea"
    sha256 monterey:       "241e1812e4aed22a524827de26069100d895112616095bc2cedf2d94f5574477"
    sha256 big_sur:        "d0f080aa74fcacedab9959c9971b8f5b215cf0eda29c93bcfab0fd79a3d8e0b7"
    sha256 catalina:       "7568c4385faf5f74893b8c93f927b95ee16daa4467bfc0c5a31da1383657747b"
    sha256 mojave:         "08261de0fa2fdecfbfd426247ca7d56fe95bad0d5e9410df69ce94bfbb789c61"
    sha256 x86_64_linux:   "073483eb6602a0c563a66f8b999763e27deb6a53bf4018b0c2267a4eebe1cec6"
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

    bdb4 = Formula["berkeley-db@4"]

    cp "OS/unsupported/Makefile-Darwin", "OS/Makefile-Darwin"
    cp "OS/unsupported/os.h-Darwin", "OS/os.h-Darwin"
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
