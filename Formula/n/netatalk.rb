class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https://netatalk.io"
  url "https://github.com/Netatalk/netatalk/releases/download/netatalk-4-3-2/netatalk-4.3.2.tar.xz"
  sha256 "2977b4fd113182f0cc183337ba23d5701fb2be4e0dfcec7ee575b4d73a738d3a"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "LGPL-2.0-only",
    "LGPL-2.1-or-later",
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
  ]
  head "https://github.com/Netatalk/netatalk.git", branch: "main"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "a996c4867d72289a1d1b6de73069dab3ff7e975f2a9e41af1572548e617e9663"
    sha256 arm64_sequoia: "33055225df69045cbc4e9b44e4830ba1dd979f83dbb15726258fb09908047819"
    sha256 arm64_sonoma:  "2ebdbc3faeb4a7ef33d4c863e7336685510e2c58ad28df1d136b0de83bc9cbbc"
    sha256 arm64_ventura: "dbac843786ce3ce67d91c56d6052f2fb5d90897abe1c0596cd22f13f687f32ba"
    sha256 sonoma:        "adb8b67efc6450b746c0fd67dacf69845207db2b32904eea20fcfc931cb5dc67"
    sha256 ventura:       "2b1cb2ab91c8e9c685dddd614dd89f2391b8de3207e21c5098bb1eb5c0a6e62e"
    sha256 arm64_linux:   "f6bb7dc5baca9769b091710448d9f6542b996778e34b86689f5f4a24e629a8d9"
    sha256 x86_64_linux:  "d55c30bfa29981cb9c05c3eb2a9e5b1ee99d35ae295e0bfbeac2e6c51ee1d093"
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

  conflicts_with "ad", because: "both install `ad` binaries"

  def install
    inreplace "distrib/initscripts/macos.netatalk.in", "@sbindir@", opt_sbin
    inreplace "distrib/initscripts/macos.netatalk.plist.in", "@bindir@", opt_bin
    inreplace "distrib/initscripts/macos.netatalk.plist.in", "@sbindir@", opt_sbin
    inreplace "distrib/initscripts/systemd.netatalk.service.in", "@sbindir@", opt_sbin
    bdb5_rpath = rpath(target: Formula["berkeley-db@5"].opt_lib)
    ENV.append "LDFLAGS", "-Wl,-rpath,#{bdb5_rpath}" if OS.linux?
    args = [
      "-Dwith-afpstats=false",
      "-Dwith-appletalk=#{OS.linux?}", # macOS doesn't have an AppleTalk stack
      "-Dwith-bdb-path=#{Formula["berkeley-db@5"].opt_prefix}",
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
      "-Dwith-spotlight=false",
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
    (testpath/"afp.conf").write <<~EOS
      [Global]
      afp port = #{port}
      log file = #{testpath}/afpd.log
      log level = default:info
      signature = 1234567890ABCDEF
    EOS
    fork do
      system sbin/"netatalk", "-d", "-F", "#{testpath}/afp.conf"
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
