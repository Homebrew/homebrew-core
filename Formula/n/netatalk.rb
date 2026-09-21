class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https://netatalk.io"
  url "https://github.com/Netatalk/netatalk/releases/download/netatalk-4-6-0/netatalk-4.6.0.tar.xz"
  sha256 "5d5756c55935df84098cfb5a2c3a90b8864a46d3c1671aa164481bced0724add"
  license all_of: [
    "GPL-2.0-or-later",

    # Licenses covering individual source files or modules. MIT is omitted because we don't install Webmin module
    "BSD-2-Clause",      # config/pap.in
    "BSD-3-Clause",      # bin/nad/nad_{cp,util}.c, etc/afpd/nfsquota.c, etc/papd/{lp,printcap}.c, ...
    "HPND",              # COPYRIGHT (Regents of The University of Michigan)
    "HPND-Pbmplus",      # COPYRIGHT (Adrian Sun)
    "Kazlib",            # etc/afpd/hash.*, include/atalk/hash.h
    "LGPL-2.0-or-later", # libatalk/unicode/charsets/mac_{centraleurope,cyrillic,greek,hebrew,turkish}.h
    "LGPL-2.1-or-later", # bin/nad/ftw.*
  ]
  head "https://github.com/Netatalk/netatalk.git", branch: "main"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_golden_gate: "ccc4b4ff5d52adf6cf5b731d76c927c29343e9a2fac46a591b60e16856f006b0"
    sha256 arm64_tahoe:       "c16fe5741ff99a7136e4d996f78f27fa9d5331c8883ec1b7f61aa64fd01c249c"
    sha256 arm64_sequoia:     "5cbf739bcf811b8adfc94bf9fe02ac6d19eb22318d59d412b8b35ebc4e2b5eeb"
    sha256 arm64_linux:       "7483021a70d0db7cd7315ea0eb501cc95863f3d2e9ceedbe0a2782fc9d57fbc5"
    sha256 x86_64_linux:      "0a437c35f02e9408f323161ea46bd7ec1607f66d83dcbbc2b4bce7672ecbb3ec"
  end

  depends_on "cmark-gfm" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "berkeley-db@5" # macOS bdb library lacks DBC type etc.
  depends_on "bstring"
  depends_on "cracklib"
  depends_on "iniparser"
  depends_on "libevent"
  depends_on "libgcrypt"
  depends_on "mariadb-connector-c"
  depends_on "openldap" # macOS LDAP.Framework is not fork safe
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "avahi" # on macOS we use native mDNS instead
    depends_on "cups" # used by the AppleTalk print server
    depends_on "libtirpc" # on macOS we use native RPC instead
    depends_on "linux-pam"
  end

  def install
    inreplace "distrib/initscripts/macos.netatalk.in", "@sbindir@", opt_sbin
    inreplace "distrib/initscripts/macos.netatalk.plist.in", "@bindir@", opt_bin
    inreplace "distrib/initscripts/macos.netatalk.plist.in", "@sbindir@", opt_sbin
    inreplace "distrib/initscripts/systemd.netatalk.service.in", "@sbindir@", opt_sbin
    bdb5_rpath = rpath(target: formula_opt_lib("berkeley-db@5"))
    ENV.append "LDFLAGS", "-Wl,-rpath,#{bdb5_rpath}" if OS.linux?
    args = [
      "-Dwith-appletalk=#{OS.linux?}", # macOS doesn't have an AppleTalk stack
      "-Dwith-bdb-path=#{formula_opt_prefix("berkeley-db@5")}",
      "-Dwith-cups-libdir-path=#{libexec}",
      "-Dwith-cups-pap-backend=#{OS.linux?}",
      "-Dwith-docs=man,readmes,html_manual",
      "-Dwith-homebrew=true",
      "-Dwith-init-dir=#{prefix}",
      "-Dwith-init-hooks=false",
      "-Dwith-install-hooks=false",
      "-Dwith-lockfile-path=#{var}/run",
      "-Dwith-pam-config-path=#{etc}/pam.d",
      "-Dwith-pkgconfdir-path=#{pkgetc}",
      "-Dwith-spotlight=true",
      "-Dwith-statedir-path=#{var}",
      "-Dwith-testsuite=true",
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  service do
    name macos: "io.netatalk.daemon", linux: "netatalk"
    require_root true
  end

  def caveats
    on_macos do
      on_arm do
        <<~EOS
          Authenticating as a system user requires manually installing the
          PAM configuration file to a predetermined location by running:

            sudo install -d -o $USER -g admin /usr/local/etc
            mkdir -p /usr/local/etc/pam.d
            cp $(brew --prefix)/etc/pam.d/netatalk /usr/local/etc/pam.d

          See `man pam.conf` for more information.
        EOS
      end
    end
  end

  test do
    pidfile = var/"run/netatalk#{".pid" if OS.mac?}"
    port = free_port
    (testpath/"afp.conf").write <<~CONF
      [Global]
      afp port = #{port}
      log file = #{testpath}/afpd.log
      log level = default:info
      signature = 1234567890ABCDEF
    CONF
    fork do
      system sbin/"netatalk", "-d", "-F", testpath/"afp.conf"
    end
    system sbin/"afpd", "-V"
    system sbin/"netatalk", "-V"
    sleep 5
    assert_match "AFP reply", shell_output("#{bin}/asip-status localhost #{port}")
    pid = pidfile.read.chomp.to_i
  ensure
    Process.kill("TERM", pid)
  end
end
