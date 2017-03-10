class PerlAT518 < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "http://www.cpan.org/src/5.0/perl-5.18.2.tar.gz"
  sha256 "7cbed5ef11900e8f68041215eea0de5e443d53393f84c41d5c9c69c150a4982f"

  keg_only :versioned_formula

  option "with-dtrace", "Build with DTrace probes"
  option "with-test", "Build and run the test suite"

  deprecated_option "use-dtrace" => "with-dtrace"
  deprecated_option "with-tests" => "with-test"

  def install
    args = [
      "-des",
      "-Dprefix=#{prefix}",
      "-Dman1dir=#{man1}",
      "-Dman3dir=#{man3}",
      "-Duseshrplib",
      "-Duselargefiles",
      "-Dusethreads",
    ]

    args << "-Dusedtrace" if build.with? "dtrace"

    system "./Configure", *args
    system "make"
    system "make", "test" if build.with? "tests"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    By default Perl installs modules in your HOME dir. If this is an issue run:
      #{bin}/cpan o conf init
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
