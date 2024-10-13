class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.4.5/irssi-1.4.5.tar.xz"
  sha256 "72a951cb0ad622785a8962801f005a3a412736c7e7e3ce152f176287c52fe062"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "4b7135b0f7e75fff21d2bb83a493bf2808f38e886ce53ad680734daeb52404c6"
    sha256 arm64_sonoma:   "9376608f394ab71d9f3ed2f89f39fb26d6673626f49b931028f0368599113ddc"
    sha256 arm64_ventura:  "46c6000387e22c3492210d205c60d371836a79070f4c9f28d1cba742bddb7c14"
    sha256 arm64_monterey: "5fa2114a1ed6bcfb0e7c0236b3f8411cf5d6bcec87d352f0a50ba2ee89ed7a37"
    sha256 sonoma:         "7ae1eee9a714ca68ee92db0cb1940b0f66631a444002303218b41fb2f3aca3e6"
    sha256 ventura:        "2ee0a18af53baa8656b69a40163a44fb303c2d65378844812b30f56f25fa5df5"
    sha256 monterey:       "7f006a852802e1b8e650b0e4a47bcce7814a5954eedf82e71f29a45ec2f9993d"
    sha256 x86_64_linux:   "4e0e4585630510c4b4df61c02103c0018f2e7fb6f1f94c4861655dd73a2f3e00"
  end

  depends_on "pkg-config" => :build
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
