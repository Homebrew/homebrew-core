class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.42.2.tar.xz"
  sha256 "0a585eeb9e363c0f80482ddb3571625250c2c86aeb408853e8ea50805cfb14bb"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  compatibility_version 1
  head "https://github.com/perl/perl5.git", branch: "blead"

  livecheck do
    url "https://www.cpan.org/src/#{version.major}.0/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c38c4726d8051ec62909766bf22f9adc4eb58cfb5986508e9db0ab4ac62c9e82"
    sha256 arm64_sequoia: "be4f87d55038181b37d0575cc078df330c69fd02830c9f88594b1862386f49f3"
    sha256 arm64_sonoma:  "da40f848051fa1c6e32325a6e3fa0f9fd75b14f7fdb328ae4b7ab822e3ba534c"
    sha256 sonoma:        "06a30da13092e77fe0bd4d7c82a6e24061d6f94db99d57f78f9e24a276decb38"
    sha256 arm64_linux:   "4e40892b92c139702ac188ebf39cf2700b88717bea16277fcc9adec42413a773"
    sha256 x86_64_linux:  "92d8ab5d61decdb5afde5e0abfeecb31a5adac7d8638e95d56daaf7248f0b6dd"
  end

  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL-3.0 restrictions
  depends_on "gdbm"

  uses_from_macos "expat"
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
      And add the following to your shell profile e.g. ~/.profile or ~/.zshrc
        eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system bin/"perl", "test.pl"
  end
end
