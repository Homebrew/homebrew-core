class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.4.5/irssi-1.4.5.tar.xz"
  sha256 "72a951cb0ad622785a8962801f005a3a412736c7e7e3ce152f176287c52fe062"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "93d6623c013c8a0706babc77ef4d9991da385e441db4cdabe08ef916008e6b94"
    sha256 arm64_sequoia: "9f640f1d64cf5331669a1f872ef3f797d4c4360015bba172c9b2ce4c48412453"
    sha256 arm64_sonoma:  "ca992d7b5d2a8af9a75712670cacccf4910fa7c706e39169037a1c957ca314f1"
    sha256 arm64_ventura: "618eb4e0270a79ba93e8a11a190c9650cbf274fb25b029b57c306c236ec68d07"
    sha256 sonoma:        "24ab2a3d9546159460cb4248a74a0548cc63799ca80ab588f52a04a159c19282"
    sha256 ventura:       "f35187d68cac2f55f1208c5ca2a362676e55fff197bea91e1a3720dd9e590f52"
    sha256 arm64_linux:   "41225f150571644cb4b871859ff86b56eac1188ba6c6694a03c3800c22e7842c"
    sha256 x86_64_linux:  "4af07634acbc8972700abb9dd307360a506032ab34eaf389fbb55780f4cd9781"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --with-proxy
      --enable-true-color
      --with-socks=no
      --with-perl=yes
      --with-perl-lib=#{lib}/perl5/site_perl
    ]

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
  end

  test do
    require "pty"

    assert_match version.to_s, shell_output("#{bin}/irssi --version")

    stdout, = PTY.spawn("#{bin}/irssi -c irc.freenode.net -n testbrew")
    assert_match "Terminal doesn't support cursor movement", stdout.readline

    # This is not how you'd use Perl with Irssi but it is enough to be
    # sure the Perl element didn't fail to compile, which is needed
    # because upstream treats Perl build failures as non-fatal.
    # To debug a Perl problem copy the following test at the end of the install
    # block to surface the relevant information from the build warnings.
    ENV["PERL5LIB"] = lib/"perl5/site_perl"
    system "perl", "-e", "use Irssi"
  end
end
