class Exim < Formula
  desc "Complete replacement for sendmail"
  homepage "https://exim.org"
  url "https://ftp.exim.org/pub/exim/exim4/exim-4.100.2.tar.xz"
  mirror "https://ftp.exim.org/pub/exim/exim4/old/exim-4.100.2.tar.xz"
  sha256 "04c9958bf15e7e3d518fb55f8b343cba4789447212bc699a9be2b1d11c1016f6"
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
    manifest_sha256 "7719de0d99926de257367a0ce45dc1af634bddc12a221760bf29829322355711"
    sha256 arm64_golden_gate: "298881768679d568f73a261f6b418bdebfaa3197e49699348ed23b9eafc6685d"
    sha256 arm64_tahoe:       "d76ef17e402c191c5f7dd1333387c96fb463a9a93335809df43df31e4361e7b9"
    sha256 arm64_sequoia:     "2462ef71804bc305ee6fe0d459bd8b99c2353cc4732e2b3904a63522a25b2742"
    sha256 arm64_linux:       "0b01ab253fb6a0e80b1eeafb5b2477f6f74443972eb16efd440cf7dfac5c9f14"
    sha256 x86_64_linux:      "ee3eb85c9622da83942a676e07863674a654a5c7eec3482d35a6ab641863b7fa"
  end

  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  resource "File::FcntlLock" do
    url "https://cpan.metacpan.org/authors/id/J/JT/JTT/File-FcntlLock-0.22.tar.gz"
    sha256 "9a9abb2efff93ab73741a128d3f700e525273546c15d04e7c51c704ab09dbcdf"

    livecheck do
      url :url
    end
  end

  deny_network_access!

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # fix `Cannot read timezone file /usr/share/zoneinfo/UTC0` issue
    ENV["TZ"] = "UTC"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    inreplace "OS/Makefile-Default", "/usr/bin/perl", formula_opt_bin("perl")/"perl" if OS.linux?

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    cp "src/EDITME", "Local/Makefile"
    inreplace "Local/Makefile" do |s|
      # Defer uid lookup on Linux to runtime
      exim_user = ENV["USER"]
      exim_user = "ref:#{exim_user}" if build.bottle? && OS.linux?

      s.change_make_var! "EXIM_USER", exim_user
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

      # Use sqlite rather than unmaintained Berkeley DB. This is the same choice
      # made by Debian while Arch Linux uses `gdbm` and Alpine uses `tdb`.
      s << "USE_SQLITE=yes\n"
      s << "DBMLIB=-lsqlite3\n"

      # Can enable sqlite feature as we already pull in sqlite dependency above
      s << "LOOKUP_SQLITE=yes\n"
    end

    cp "OS/unsupported/Makefile-Darwin", "OS/Makefile-Darwin"
    cp "OS/unsupported/os.h-Darwin", "OS/os.h-Darwin"
    inreplace "OS/Makefile-Darwin" do |s|
      s.remove_make_var! %w[CC CFLAGS]
    end

    # The compile script ignores CPPFLAGS
    ENV.append "CFLAGS", ENV.cppflags

    ENV.deparallelize # See: https://lists.exim.org/lurker/thread/20111109.083524.87c96d9b.en.html
    system "make"
    system "make", "INSTALL_ARG=-no_chown", "install"
    man8.install "doc/exim.8"
    # Inspired by MacPorts startup script. Fixes restart issue due to missing setuid.
    (bin/"exim_ctl").write <<~SH
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
    SH
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
