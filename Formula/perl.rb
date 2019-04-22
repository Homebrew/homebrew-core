class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.28.2.tar.gz"
  sha256 "aa95456dddb3eb1cc5475fed4e08f91876bea71fb636fba6399054dfbabed6c7"
  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    rebuild 2
    sha256 "6f9c6519a6c95eb3212abde423688fa01d3d56be0c424f9e6e8bed7b59dfe014" => :mojave
    sha256 "b04e2b8a5158c6405558e8408d901c7c1899eda8950202f1dfddd6efd7cfa043" => :high_sierra
    sha256 "8099f37b2521864a095eb06dc5cde02805421a78ddda95fafe3fc538a3ef3553" => :sierra
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

    system "make"
    system "make", "test"

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
