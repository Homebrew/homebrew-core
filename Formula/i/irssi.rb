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
    sha256 arm64_tahoe:   "320bd94484beb359b8a802a58496e081ddbf4c5fd1160e614c72e0a8db23d1a8"
    sha256 arm64_sequoia: "69df4f8eb16990eb29a65c168fcbd296400c2d71645f9d230ef5bda0279b9596"
    sha256 arm64_sonoma:  "52a6038357be2290d73699c90c3d562621b2a4c0701dec7d8f156e0977ebaa7d"
    sha256 sonoma:        "29de29330e0ffc6cacfcea52980e9ce81e87e63164938d3b4a9e141abcd8a9c2"
    sha256 arm64_linux:   "3f5dfe48c7d5a032a1cb69ac5327ecda63bb65d309033e10d8f81b24cb096607"
    sha256 x86_64_linux:  "444b5e769de9168ffa56ce868435b86ecf8963eb3998e2b83885e4605c97d911"
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
