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
    rebuild 2
    sha256 arm64_tahoe:   "380f42555868ac5b61259d1dddcd47d94d15e3b86829b379b750beaf2a47c6c9"
    sha256 arm64_sequoia: "6cda96f843ce728a0493321ca5b9003a37ff61013939697bd314b168b7fd9ebd"
    sha256 arm64_sonoma:  "e7aef7fff21ebc2f2e6abe9dba1768307bf2eb454a1ddba7a085c166bcb599ad"
    sha256 sonoma:        "83c6d196ae4f4ddd984ae7b056de427a0ffb59118c4e3a29261e2aab483b0aba"
    sha256 arm64_linux:   "5b9b324500185f2ab9dd750ab8d32c8318ae26f7baf077ec6837ee273c648df4"
    sha256 x86_64_linux:  "b304553e132ba3665e7a2b6daca8393da7c6a4ec4ef24141dd437c979edd33be"
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
