class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.32.0.tar.xz"
  sha256 "6f436b447cf56d22464f980fac1916e707a040e96d52172984c5d184c09b859b"
  head "https://github.com/perl/perl5.git", :branch => "blead"

  bottle do
    sha256 "8e69722fc2dd90fa4dd58a3c2da45d7d3a2b8645d7732de9a027b918e3747be4" => :catalina
    sha256 "ab24969b88ed0df15561486ebfae22b58e77cde35202ad25c8f8f0fdef0eb91d" => :mojave
    sha256 "94bc7fe38a04bedbaaccfcfdee8d41b38e4b240e9317009a158ca48cebca3685" => :high_sierra
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
      -Dsed=/usr/bin/sed
    ]

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
