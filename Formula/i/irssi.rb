class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.4.5/irssi-1.4.5.tar.xz"
  sha256 "72a951cb0ad622785a8962801f005a3a412736c7e7e3ce152f176287c52fe062"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "8abd032e0f87f1a0a6ada2bc59ff4c5ecf8741e30ec5e60810f4f05f3659abf0"
    sha256 arm64_tahoe:       "63a9bacb5877588da97645351c1b2db8709421a909787e11da2663b34331f5c3"
    sha256 arm64_sequoia:     "dd157a807bfb407c75deac84ecccb71acb21afe9d82b458d5d5749d76df25ca4"
    sha256 arm64_linux:       "6207bbec2b3944dca829886bec462824f0192f89b9d61bdfd2afb69e70ee279d"
    sha256 x86_64_linux:      "11aec7b48552d3ce880b87262551b9eefe1251e7850124b66bc2f996d7aa05f1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "openssl@4"
  depends_on "perl"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    perl_vendorarch = Utils.safe_popen_read("perl", "-MConfig", "-e", "print $Config{vendorarch}")

    args = %W[
      -Dwith-proxy=yes
      -Dwith-perl=yes
      -Dwith-perl-lib=#{perl_vendorarch.sub(HOMEBREW_PREFIX, prefix)}
    ]

    # Add RPATH to Perl modules so Homebrew's audit can find libperl.so.
    # The modules are loaded by Perl (which already has libperl), so this
    # isn't strictly needed at runtime, but satisfies the linkage check.
    if OS.linux?
      perl_archlib = Utils.safe_popen_read("perl", "-MConfig", "-e", "print $Config{archlib}")
      ENV.append "LDFLAGS", "-Wl,-rpath,#{perl_archlib}/CORE"
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    require "pty"

    assert_match version.to_s, shell_output("#{bin}/irssi --version")

    stdout, = PTY.spawn("#{bin}/irssi -c irc.freenode.net -n testbrew")
    assert_match "Terminal doesn't support cursor movement", stdout.readline

    # Verify the Perl module compiled successfully. Upstream treats Perl
    # build failures as non-fatal, so they can go unnoticed. To debug,
    # move this test into the install block to surface build warnings.
    system "perl", "-e", "use Irssi"
  end
end
