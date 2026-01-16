class Exim < Formula
  desc "Complete replacement for sendmail"
  homepage "https://exim.org"
  url "https://ftp.exim.org/pub/exim/exim4/exim-4.99.1.tar.xz"
  sha256 "eae967bd49a5f879933b8c6ec88c30475a1c6646232135f37f05b55dbc4e3447"
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
    sha256 arm64_tahoe:   "f30b5fb4ddfe468ff0fce759bf838f4a76aec6fd314e3ca9786888b58f536641"
    sha256 arm64_sequoia: "4d32185f2ae6fbb94dee3225296bd5299dd104abe2224fa702cfded059625cb6"
    sha256 arm64_sonoma:  "927bcf3c9e21ab0fcde29d977b9ddec1d705c2baec59b1c8d786f8ec9281ac00"
    sha256 sonoma:        "65e07005ecf7768db165df514066c69fa528bb1cfdd337b0aa66c5013ee946e1"
    sha256 arm64_linux:   "153c3b6bd5c6a987b040b2146627c7cbde3ed124d14c9c070ed0e973ec081b6a"
    sha256 x86_64_linux:  "bd001246d091daf1f2016aa7168dda7afb9e626496b8286c6b6cb422d9fb9094"
  end

  depends_on "berkeley-db@5"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"
  uses_from_macos "perl"

  resource "File::Next" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/File-Next-1.18.tar.gz"
    sha256 "f900cb39505eb6e168a9ca51a10b73f1bbde1914b923a09ecd72d9c02e6ec2ef"
  end

  resource "File::FcntlLock" do
    url "https://cpan.metacpan.org/authors/id/J/JT/JTT/File-FcntlLock-0.22.tar.gz"
    sha256 "9a9abb2efff93ab73741a128d3f700e525273546c15d04e7c51c704ab09dbcdf"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # fix `Cannot read timezone file /usr/share/zoneinfo/UTC0` issue
    ENV["TZ"] = "UTC"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    inreplace "OS/Makefile-Default", "/usr/bin/perl", Formula["perl"].opt_bin/"perl" if OS.linux?

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

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
