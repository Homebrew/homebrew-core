class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.28.1.tar.gz"
  sha256 "3ebf85fe65df2ee165b22596540b7d5d42f84d4b72d84834f74e2e0b8956c347"
  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    rebuild 1
    sha256 "43aa43e43550d9f9999cc6e21fd6ec79fabbc6729dab1f4452560d8cb67a4073" => :mojave
    sha256 "a0f566f25152483017143cf050f40332ba3f4c8538ec5a4b88762fefa5a1b401" => :high_sierra
    sha256 "d3bde88300c7aefcff1008734861196bcaed43e8a58932c533434bbd85e7d71e" => :sierra
  end

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

    # macOS's SIP feature prevents DYLD_LIBRARY_PATH from being passed to child
    # processes, which causes the `make test` step to fail.
    # https://rt.perl.org/Ticket/Display.html?id=126706
    # https://github.com/Homebrew/legacy-homebrew/issues/41716
    # As of perl 5.28.0 `make` fails, too, so work around it with a symlink.
    # Reported 25 Jun 2018 https://rt.perl.org/Ticket/Display.html?id=133306
    (lib/"perl5/#{version}/darwin-thread-multi-2level/CORE").install_symlink buildpath/"libperl.dylib"

    system "make"
    system "make", "test" if build.bottle?

    # Remove the symlink so the library actually gets installed.
    rm lib/"perl5/#{version}/darwin-thread-multi-2level/CORE/libperl.dylib"

    system "make", "install"
  end

  def caveats; <<~EOS
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
