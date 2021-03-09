class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.32.1.tar.xz"
  sha256 "57cc47c735c8300a8ce2fa0643507b44c4ae59012bfdad0121313db639e02309"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 1
  head "https://github.com/perl/perl5.git", branch: "blead"

  livecheck do
    url "https://www.cpan.org/src/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "900ac321ecfc07d89588b203a6860fe3f3ba056a3565225d77115c99d651aed0"
    sha256 big_sur:       "5178a634bfb37437ee40d836c3bacb1adb89516a553ef6a8c2d40cee9eea608b"
    sha256 catalina:      "7ac87157d98223abcc2b25e35811c9dfd016f807454ec8fc219a910b4a9cdacc"
    sha256 mojave:        "2663e8ce52b4fb4fab170e19fff638e0b65688a933a3cddd86696403323be88d"
  end

  depends_on "berkeley-db"
  depends_on "gdbm"

  uses_from_macos "expat"

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  def install
    args = %W[
      -des
      -Dprefix=#{prefix}
      -Dprivlib=#{lib}/perl5/#{version}
      -Dsitelib=#{lib}/perl5/site_perl/#{version}
      -Dotherlibdirs=#{HOMEBREW_PREFIX}/lib/perl5/site_perl/#{version}
      -Dperlpath=#{opt_bin}/perl
      -Dstartperl=#!#{opt_bin}/perl
      -Dman1dir=#{man1}
      -Dman3dir=#{man3}
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]
    on_macos do
      args << "-Dsed=/usr/bin/sed"
    end

    args << "-Dusedevel" if build.head?

    system "./Configure", *args

    system "make"

    system "make", "install"
  end

  def caveats
    <<~EOS
      By default non-brewed cpan modules are installed to the Cellar. If you wish
      for your modules to persist across updates we recommend using `local::lib`.

      You can set that up like this:
        PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
        echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"' >> #{shell_profile}
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
