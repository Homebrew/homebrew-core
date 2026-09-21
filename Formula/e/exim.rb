class Exim < Formula
  desc "Complete replacement for sendmail"
  homepage "https://exim.org"
  url "https://ftp.exim.org/pub/exim/exim4/exim-4.100.1.tar.xz"
  mirror "https://ftp.exim.org/pub/exim/exim4/old/exim-4.100.1.tar.xz"
  sha256 "e9fb41f6724a5b136d64c9d19dbc5f26494af879a3e7e3190f91639eaa79fa0d"
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
    sha256 arm64_golden_gate: "93457cc469268b4a60a73d01f590e67d1ea8c98b3ccf4ab8fe0dd3b8a84325c7"
    sha256 arm64_tahoe:       "ad3d7dc027f383803ae7d186169511ade5626e9ab90b2d344d306500be74cde7"
    sha256 arm64_sequoia:     "9d3e150fb0edb711f78c118b9da90de3dcc604f23d3938fe5cf20e82ea922629"
    sha256 arm64_linux:       "db3d6f92c3d7656047fd777c10c724003b7bdfe6984e3e56401bab46817ce9fe"
    sha256 x86_64_linux:      "fd671028d9126a09d7b16309162146caf35e455af5f867cdff4e1121e4ee4406"
  end

  depends_on "openssl@3"
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
    (bin/"exim_ctl").write startup_script
  end

  # Inspired by MacPorts startup script. Fixes restart issue due to missing setuid.
  def startup_script
    <<~SH
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
