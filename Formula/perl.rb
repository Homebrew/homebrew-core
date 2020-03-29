class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.30.1.tar.gz"
  sha256 "bf3d25571ff1ee94186177c2cdef87867fd6a14aa5a84f0b1fb7bf798f42f964"
  head "https://github.com/perl/perl5.git", :branch => "blead"

  bottle do
    sha256 "c67104091d5328aadb95532ceb7aa4b25544c2505acd11522b5615b67953d38f" => :catalina
    sha256 "38e242ca4adaad6c0ef271e8e7d77030998f5809daf1b90c208d81b8b75fb5c9" => :mojave
    sha256 "73e7650fd86f600e3342cd14491e632c0bae0c541476ab5c30b4409deedf7664" => :high_sierra
  end

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

    args << "-Dusedevel" if build.head?

    system "./Configure", *args

    system "make"
    system "make", "test"

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
