class PerlAT514 < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.14.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/perl/perl_5.14.2.orig.tar.bz2"
  sha256 "803fd44c492fcef79fda456a6f50455766e00ddec2e568a543630f65ff3f44cb"

  bottle do
    sha256 "e4f4b46b3505bff84553c33ffb0422132726b2c71e3daa16869632aba15410b1" => :sierra
    sha256 "4d3d3954696d31de35a1152a1777eaef3bc847f2129ba8b33d80c3fa0c95ea55" => :el_capitan
    sha256 "1f9dafd45c73c84ecaf87c0f0c7528b4070e2d7f394f0d6ae56b771259695d67" => :yosemite
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
