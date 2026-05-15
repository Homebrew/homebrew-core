class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https://netatalk.io"
  url "https://github.com/Netatalk/netatalk/releases/download/netatalk-4-4-3/netatalk-4.4.3.tar.xz"
  sha256 "863d640ecc99f4923ead6c58e8d3406ab3a1ca9dd3b0d47ccdf6fdebb6efe3ab"
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
    sha256 arm64_tahoe:   "042b6b1d40fd13796fec48ffa3cc7d414bee5d57397de5e900ffa1cfcc35d9c8"
    sha256 arm64_sequoia: "f80a29fe3c78e245cbfb5e90b924da5fa86a0e98832d667c03d6e62cbcc636f4"
    sha256 arm64_sonoma:  "17de978a5d35cc04c6a7a1e89addb3764e47004bf640c84ff1d0d78933c5ec29"
    sha256 sonoma:        "c66cb7e6ecc6608c1048742846737d0a7741edfc14472c1d28420d6c36ee0ba5"
    sha256 arm64_linux:   "dbe86d95776a543d735832f1e878215a052a69c94c74e152ee240ca1b933a941"
    sha256 x86_64_linux:  "200f9019295e1e04a107f20f34cc7966a1b680acfca5e206d58f408c73403a9b"
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
