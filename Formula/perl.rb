class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.32.0.tar.xz"
  sha256 "6f436b447cf56d22464f980fac1916e707a040e96d52172984c5d184c09b859b"
  license "Artistic-1.0-Perl"
  head "https://github.com/perl/perl5.git", branch: "blead"

  livecheck do
    url "https://www.cpan.org/src/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "bc6c97521b6edf723c8ee0742aebb1954b5c8fec81bf2d96861c3f8bcc4e404d" => :catalina
    sha256 "f09b3fefe2175b36e590ee13e7aa84d28ebcbce3ef8e252e24a0aebb752405ab" => :mojave
    sha256 "718a54da6e3b02c33d5230776aaa54eaaac710c09cf412078014c9c50dd0ac51" => :high_sierra
  end

  uses_from_macos "expat"

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  patch do
    # Enable build support on macOS 11.x
    # Remove when https://github.com/Perl/perl5/pull/17946 is merged
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/526faca9830646b974f563532fa27a1515e51ca1/perl/version_check.patch"
    sha256 "cff250437f141eb677ec2215a9f2dfcbacba77304dac06499db6c722c9d30b58"
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
