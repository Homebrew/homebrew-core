class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "http://www.cpan.org/src/5.0/perl-5.24.0.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/perl/perl_5.24.0.orig.tar.xz"
  sha256 "a9a37c0860380ecd7b23aa06d61c20fc5bc6d95198029f3684c44a9d7e2952f2"
  revision 1

  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    sha256 "318daffb06729e7b46543310d568020dac45de0f420ec76e327ab762fd1c8f02" => :sierra
    sha256 "9b7e0cea4fdb51a17bed1d7733d300a33e29186c8f5e7afc601e7cbbfda20f8e" => :el_capitan
    sha256 "75876c7d492a675d3a1fd257afd10d2c30fdb339ba53de925ab97fcdc97b9131" => :yosemite
    sha256 "a2e15a577db6428bfaad8c441973d85cfdea65bf6ed54d8c4c36b8d767d1fa62" => :mavericks
  end

  option "with-dtrace", "Build with DTrace probes"
  option "without-test", "Skip running the build test suite"

  deprecated_option "with-tests" => "with-test"

  # Fixes Time::HiRes module bug related to the presence of clock_gettime
  # https://rt.perl.org/Public/Bug/Display.html?id=128427
  # Merged upstream, should be in the next release.
  if MacOS.version >= :sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b18137128c4e0cb7e92e9ee007a9f78bc9d03b21/perl/clock_gettime.patch"
      sha256 "612825c24ed19d6fa255bb42af59dff46ee65c16ea77abf4a59b754aa8ab05ac"
    end
  end

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

    args << "-Dusedtrace" if build.with? "dtrace"
    args << "-Dusedevel" if build.head?

    system "./Configure", *args
    system "make"

    # OS X El Capitan's SIP feature prevents DYLD_LIBRARY_PATH from being
    # passed to child processes, which causes the make test step to fail.
    # https://rt.perl.org/Ticket/Display.html?id=126706
    # https://github.com/Homebrew/legacy-homebrew/issues/41716
    if MacOS.version < :el_capitan
      system "make", "test" if build.with? "test"
    end

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    By default non-brewed cpan modules are installed to the Cellar. If you wish
    for your modules to persist across updates we recommend using `local::lib`.

    You can set that up like this:
      PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
      echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"' >> #{shell_profile}
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
