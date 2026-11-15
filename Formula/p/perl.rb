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
    rebuild 1
    sha256 arm64_golden_gate: "112e18c3c12684a683ed68a2899f5891ca292c629dacd5aac44d4741120b477d"
    sha256 arm64_tahoe:       "3933a5884ef2db18d9fc0681c5aa977877249f088781fc55a69f075bb9bf8715"
    sha256 arm64_sequoia:     "1d63c5b5b743b9d30ea425ecd9d6bf6adabcff7848c33136f404cf602ccc7662"
    sha256 arm64_linux:       "6de7e6ae13d1f1e02b9f2497cc747d96c2e30ca3797042bae01633e97031298e"
    sha256 x86_64_linux:      "30389a67e4de441632b29645353b8ed1b3e774310abc910e5f1a6e04a9384eca"
  end

  depends_on "gdbm"

  uses_from_macos "libxcrypt"

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  deny_network_access!

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
      -Dman3ext=3pm
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
