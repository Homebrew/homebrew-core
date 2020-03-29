class PerlAT518 < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.18.4.tar.gz"
  sha256 "01a4e11a9a34616396c4a77b3cef51f76a297e1a2c2c490ae6138bf0351eb29f"

  bottle do
    sha256 "bdfac28ec4bf1ea1859b23564e0e4fd80ffe5ec5f7b54efc21cf8f1c47b396b8" => :high_sierra
    sha256 "a73a2bbb48200827c3cca867b2145808735e5f250af55a01580fffd875da983e" => :sierra
    sha256 "a4400e07a3930625832082f113abbd9069f818dc22c1bac17b23e99edaff66ff" => :el_capitan
  end

  keg_only :versioned_formula

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

    system "./Configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      By default Perl installs modules in your HOME dir. If this is an issue run:
        #{bin}/cpan o conf init
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
