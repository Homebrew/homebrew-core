class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https://netatalk.io"
  url "https://github.com/Netatalk/netatalk/releases/download/netatalk-4-6-1/netatalk-4.6.1.tar.xz"
  sha256 "c97412f7f4bbbbfa922664f52b9d6a5f75282b99a52fe0463134bb477fea715e"
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
    sha256 arm64_golden_gate: "08c2caee748401e936f474aef60e3bd0d4dbc59bd6a5112e5ed3ddd533f99c0e"
    sha256 arm64_tahoe:       "8fbac1d7eb89c27713d3c95128842b857a8f209e03f0277d33a7a67967239813"
    sha256 arm64_sequoia:     "5822fc3d52d64a08cdbef179387a9e45203d03f506fffbc6f2169c74996c4093"
    sha256 arm64_linux:       "b04267cff2eff9341fceffa498b376a3ba8ec85eb062e13d9256f1aeade2ff06"
    sha256 x86_64_linux:      "e98684955f95fdb87d7ce789df595437557bc0a7a0d53a15200fb17f476957dd"
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

  allow_network_access! :test

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
