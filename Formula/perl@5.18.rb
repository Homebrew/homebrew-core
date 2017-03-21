class PerlAT518 < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.18.2.tar.gz"
  sha256 "7cbed5ef11900e8f68041215eea0de5e443d53393f84c41d5c9c69c150a4982f"

  bottle do
    sha256 "bd7cec940fcec85651d37e00c6f3b073c4f0e7c6dc82d8836276947a504dd169" => :sierra
    sha256 "5ea15144192fc50417125abb4735272d95a0ae7602b99deaca7e316b3cce3dd8" => :el_capitan
    sha256 "dd567491e3d46487ec5657ec381a991164205c043798973c949498ead69e5519" => :yosemite
  end

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
