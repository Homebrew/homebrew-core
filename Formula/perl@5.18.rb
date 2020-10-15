class PerlAT518 < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.18.4.tar.gz"
  sha256 "01a4e11a9a34616396c4a77b3cef51f76a297e1a2c2c490ae6138bf0351eb29f"
  license "Artistic-1.0-Perl"
  revision 1

  livecheck do
    url "https://www.cpan.org/src/5.0/"
    regex(/href=.*?perl[._-]v?(5\.18(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "45b388773570fd4ef892caa7a0bb0312fd05dfcb3f73245a03eed16bf9187cc9" => :catalina
    sha256 "3e80537039afd47db55b42a09f34c2b1e6fc2a24581c16d09d76b5ad85997ed6" => :mojave
    sha256 "4ebffdb24ede27bf2fb4f844c87f4adc962942d399c6762b3c6cf90b929fa50a" => :high_sierra
  end

  keg_only :versioned_formula

  def install
    ENV.deparallelize if MacOS.version >= :catalina

    args = %W[
      -des
      -Dprefix=#{prefix}
      -Dman1dir=#{man1}
      -Dman3dir=#{man3}
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
      -Dsed=/usr/bin/sed
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
