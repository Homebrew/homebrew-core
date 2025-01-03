class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https://netatalk.io"
  url "https://github.com/Netatalk/netatalk/releases/download/netatalk-4-0-8/netatalk-4.0.8.tar.xz"
  sha256 "d09d591521b27b91b1c2a6255a2e059af8c9fda43570f983f0a145706e5f7628"
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

  depends_on "docbook-xsl" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "berkeley-db@5" # macOS bdb library lacks DBC type etc.
  depends_on "cracklib"
  depends_on "libevent"
  depends_on "libgcrypt"
  depends_on "mysql"
  depends_on "openldap" # macOS LDAP.Framework is not fork safe

  uses_from_macos "libxslt" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"

  on_linux do
    depends_on "avahi" # on macOS we use native mDNS instead
    depends_on "cups" # used by the AppleTalk print server
    depends_on "dbus" # required by avahi
    depends_on "libtirpc" # on macOS we use native RPC instead
  end

  def install
    bdb5_rpath = rpath(target: Formula["berkeley-db@5"].opt_lib)
    ENV.append "LDFLAGS", "-Wl,-rpath,#{bdb5_rpath}" if OS.linux?
    args = [
      "-Dwith-afpstats=false",
      "-Dwith-appletalk=#{OS.linux?}", # macOS doesn't have an AppleTalk stack
      "-Dwith-bdb-path=#{Formula["berkeley-db@5"].opt_prefix}",
      "-Dwith-docbook-path=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl",
      "-Dwith-init-style=none",
      "-Dwith-install-hooks=false",
      "-Dwith-pam-config-path=#{etc}/pam.d",
      "-Dwith-rpath=false",
      "-Dwith-spotlight=false",
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin/"netatalk", "-V"
    system sbin/"afpd", "-V"
    assert_empty shell_output(sbin/"netatalk")
  end
end
