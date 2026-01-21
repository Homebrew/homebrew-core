class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.4.5/irssi-1.4.5.tar.xz"
  sha256 "72a951cb0ad622785a8962801f005a3a412736c7e7e3ce152f176287c52fe062"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "e838b3335dd0b71b4b964e940581f17d1d5fc8a119ffe39cd82b56e2988c5898"
    sha256 arm64_sequoia: "9c578d13963910805f69c3134b94f56ee2539b48bab23f09f8ba5e91cf5bb715"
    sha256 arm64_sonoma:  "829ab4654ce73add153d8ce958261a01546bc336c5492e996b9da46616fe7410"
    sha256 sonoma:        "325ec802f037de5afdfd31447b888796f7baabb9dbcbe82b2b1aab13e00f0a8d"
    sha256 arm64_linux:   "051d92da2db9dcd16362dc6204dcff2ef9bebbfd337c05a3848e9f3823c67c63"
    sha256 x86_64_linux:  "b6b393fae0dd1c43829314886be5ee26018a3ed2b8ea18c633d0e9ed37c7d642"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "openssl@3"
  depends_on "perl"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -Dwith-proxy=yes
      -Dwith-perl=yes
      -Dwith-perl-lib=#{lib}/perl5/site_perl
    ]

    # Add RPATH to Perl modules so Homebrew's audit can find libperl.so.
    # The modules are loaded by Perl (which already has libperl), so this
    # isn't strictly needed at runtime, but satisfies the linkage check.
    if OS.linux?
      perl = Formula["perl"]
      perlarch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch
      perl_core = perl.opt_lib/"perl5"/perl.version.major_minor/"#{perlarch}-linux-thread-multi/CORE"
      ENV.append "LDFLAGS", "-Wl,-rpath,#{perl_core}"
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
    ENV["PERL5LIB"] = lib/"perl5/site_perl"
    system "perl", "-e", "use Irssi"
  end
end
