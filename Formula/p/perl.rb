class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.44.0.tar.xz"
  mirror "http://www.cpan.org/src/5.0/perl-5.44.0.tar.xz"
  sha256 "505cf43912e9480495c344c70260452e32aa2a73c546a026b3f100053b23ce91"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  compatibility_version 2
  head "https://github.com/perl/perl5.git", branch: "blead"

  livecheck do
    url "https://www.cpan.org/src/#{version.major}.0/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d0978a92bfa545e49bf6dd16ce65d864c4f1d8c79105bab702845c1b16ddf5a9"
    sha256 arm64_sequoia: "2bd60c90c3a42cca58058a7158affc1df1bcf3ef411e0e8722320720537091f8"
    sha256 arm64_sonoma:  "e5050ff19ceff250467139163ebfa608a46f1ddf9dde633be2ec6825e42b04c9"
    sha256 sequoia:       "d6597a6ca568ceb53f8d8b6086f7fe746e30b6af49fbea3830a47eb572a71de7"
    sha256 sonoma:        "785dbb6aeb21f3be8cc2ca414756f001879533b23ba91cb796f9b55be7e3f669"
    sha256 arm64_linux:   "9c505ddbdf12eb5fb761f6ae5a9c6b0ce6659e058ae26d0beb3bdc7a968e81e5"
    sha256 x86_64_linux:  "d497cdf66dd8e426392d85902d59e2644d46195dd3dead1c17ac6f533fa12f41"
  end

  depends_on "gdbm"

  uses_from_macos "libxcrypt"

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  def install
    args = %W[
      -des
      -Dinstallstyle=lib/perl5
      -Dinstallprefix=#{prefix}
      -Dprefix=#{opt_prefix}
      -Dprivlib=#{opt_lib}/perl5/#{version.major_minor}
      -Dsitelib=#{opt_lib}/perl5/site_perl/#{version.major_minor}
      -Dotherlibdirs=#{HOMEBREW_PREFIX}/lib/perl5/site_perl/#{version.major_minor}
      -Dvendorlib=#{HOMEBREW_PREFIX}/lib/perl5/vendor_perl/#{version.major_minor}
      -Dvendorprefix=#{HOMEBREW_PREFIX}
      -Dperlpath=#{opt_bin}/perl
      -Dstartperl=#!#{opt_bin}/perl
      -Dman1dir=#{opt_share}/man/man1
      -Dman3dir=#{opt_share}/man/man3
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]
    args << "-Dusedevel" if build.head?

    # On macOS, we can use Apple's system library to support DB_File module.
    # On Linux, we explicitly exclude bundled DB_File to avoid opportunistic
    # linkage to Berkeley DB. Dependents and users can install it from CPAN.
    args << "-Ui_db" unless OS.mac?

    system "./Configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    s = <<~EOS
      By default non-brewed cpan modules are installed to the Cellar. If you wish
      for your modules to persist across updates we recommend using `local::lib`.

      You can set that up like this:
        PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
      And add the following to your shell profile e.g. ~/.profile or ~/.zshrc
        eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
    EOS
    on_linux do
      s += <<~EOS

        Bundled DB_File module was not installed. If needed, you can install it from CPAN.
      EOS
    end
    s
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system bin/"perl", "test.pl"
  end
end
