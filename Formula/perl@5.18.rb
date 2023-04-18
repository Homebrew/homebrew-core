class PerlAT518 < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.18.4.tar.gz"
  sha256 "01a4e11a9a34616396c4a77b3cef51f76a297e1a2c2c490ae6138bf0351eb29f"
  license "Artistic-1.0-Perl"
  revision 1

  bottle do
    sha256 arm64_ventura:  "45502e783b4e89f4eb5392227e79a80313e46c9f5d10397b07ef80d2bc6c9d2b"
    sha256 arm64_monterey: "c331f308c1f7b2df92aaa51b30a4ff049454e2c1218843ae9e493db403ec165f"
    sha256 arm64_big_sur:  "6c250f7fbbb0cbc997ad0068b88802f5d097f3b3a635d5c64d7267c3ab39340f"
    sha256 ventura:        "b5a9adf58ee29a45a3824d268ee4dd18f96a7ec29c560d18d231287f99b59def"
    sha256 monterey:       "73812816ce2e3a511f5b4bf371ac8a0330c8e9ad46463ecb2fc42dde62d93a00"
    sha256 big_sur:        "6a0597d8cea75db2fecaf1e807777b2f55b3fcdad4721630bc1e5c062a9ec8a0"
    sha256 catalina:       "45b388773570fd4ef892caa7a0bb0312fd05dfcb3f73245a03eed16bf9187cc9"
    sha256 mojave:         "3e80537039afd47db55b42a09f34c2b1e6fc2a24581c16d09d76b5ad85997ed6"
    sha256 high_sierra:    "4ebffdb24ede27bf2fb4f844c87f4adc962942d399c6762b3c6cf90b929fa50a"
    sha256 x86_64_linux:   "e4ce31234d1576e6c5af1bf1054487b7a0a740d1cba234a8bde56dc72e0250b2"
  end

  keg_only :versioned_formula

  # https://www.cpan.org/src/ lists 5.18 as end-of-life and also
  # states that "branches earlier than 5.20 are no longer supported"
  deprecate! date: "2022-08-16", because: :deprecated_upstream

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
    ]
    args << "-Dsed=/usr/bin/sed" if OS.mac?

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
