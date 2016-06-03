class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "http://www.cpan.org/src/5.0/perl-5.24.0.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/perl/perl_5.24.0.orig.tar.xz"
  sha256 "a9a37c0860380ecd7b23aa06d61c20fc5bc6d95198029f3684c44a9d7e2952f2"

  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    sha256 "90dfafc8f1f30af8d03ad41dcea82e25296a2d41496cfb93ffa7fc862cbc616e" => :el_capitan
    sha256 "2981babc6c83b11e534b25777f03273c9ff56fd58f576291abf5547b3e07767c" => :yosemite
    sha256 "707b9d6d071aca1cccde5234271aedc16d126330614afd06551c17badadf349c" => :mavericks
  end

  option "with-dtrace", "Build with DTrace probes"
  option "without-test", "Skip running the build test suite"

  deprecated_option "with-tests" => "with-test"

  def install
    args = %W[
      -des
      -Dprefix=#{prefix}
      -Dprivlib=#{lib}/perl5/#{version}
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
    By default Perl installs modules in your HOME dir. If this is an issue run:
      `#{opt_bin}/cpan o conf init`
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
