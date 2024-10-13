class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.38.2.tar.xz"
  sha256 "d91115e90b896520e83d4de6b52f8254ef2b70a8d545ffab33200ea9f1cf29e8"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 1
  head "https://github.com/perl/perl5.git", branch: "blead"

  livecheck do
    url "https://www.cpan.org/src/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "f3039ca342464845898d1f7dc9bd1aab6ef5929106cbf813dda587b583ad0411"
    sha256 arm64_sonoma:   "222658f33257e002c74b8720fba0b90d12eba566837014df20494a8721cb1642"
    sha256 arm64_ventura:  "dcbb3ecc956e00d07f6c17a242975fba48af6147ac732ed5ec78ffef006be7c7"
    sha256 arm64_monterey: "ac667b52851c7f6052ec88a7f7a922f8d85a25b96ba8d7e756d728338ddc5203"
    sha256 sonoma:         "4da05eef811a965977571311b16877bfd281c01494e315125143ba8e7150183e"
    sha256 ventura:        "b7705031b119b02bbedeff51af5bdd869043af576b7656915c1558ccf91232d4"
    sha256 monterey:       "37618ba7d8642b1456c3dc915eaa8c8e22f3ac3d25df5fc3c89c10412a372192"
    sha256 x86_64_linux:   "8c6038740fee1c2084880a53765c23c2d972447e2f960e75bdcb071b0a434c2f"
  end

  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL-3.0 restrictions
  depends_on "gdbm"

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  def install
    args = %W[
      -des
      -Dinstallstyle=lib/perl5
      -Dinstallprefix=#{prefix}
      -Dprefix=#{opt_prefix}
      -Dprivlib=#{opt_lib}/perl5/#{version.major_minor}
      -Dsitelib=#{opt_lib}/perl5/site_perl/#{version.major_minor}
      -Dotherlibdirs=#{HOMEBREW_PREFIX}/lib/perl5/site_perl/#{version.major_minor}
      -Dperlpath=#{opt_bin}/perl
      -Dstartperl=#!#{opt_bin}/perl
      -Dman1dir=#{opt_share}/man/man1
      -Dman3dir=#{opt_share}/man/man3
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]
    args << "-Dusedevel" if build.head?

    system "./Configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    if OS.linux?
      perl_archlib = Utils.safe_popen_read(bin/"perl", "-MConfig", "-e", "print $Config{archlib}")
      perl_core = Pathname.new(perl_archlib)/"CORE"
      if File.readlines("#{perl_core}/perl.h").grep(/include <xlocale.h>/).any? &&
         (OS::Linux::Glibc.system_version >= "2.26" ||
         (Formula["glibc"].any_version_installed? && Formula["glibc"].version >= "2.26"))
        # Glibc does not provide the xlocale.h file since version 2.26
        # Patch the perl.h file to be able to use perl on newer versions.
        # locale.h includes xlocale.h if the latter one exists
        inreplace "#{perl_core}/perl.h", "include <xlocale.h>", "include <locale.h>"
      end
    end
  end

  def caveats
    <<~EOS
      By default non-brewed cpan modules are installed to the Cellar. If you wish
      for your modules to persist across updates we recommend using `local::lib`.

      You can set that up like this:
        PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
      And add the following to your shell profile e.g. ~/.profile or ~/.zshrc
        eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system bin/"perl", "test.pl"
  end
end
