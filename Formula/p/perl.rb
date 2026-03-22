class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.42.1.tar.xz"
  sha256 "098c7f76e7a28443f6403610c7e339777905360c5225798fd142b8d33b05c6b4"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 1
  compatibility_version 1
  head "https://github.com/perl/perl5.git", branch: "blead"

  livecheck do
    url "https://www.cpan.org/src/#{version.major}.0/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8143bb35b0370cc5c69022d3aeb32f502dc2f8a92996ac621847ab17b7ba0da9"
    sha256 arm64_sequoia: "4de2d682352ccb3f5943a38e9663f21bb35df41bb012b2036548237c9b23079e"
    sha256 arm64_sonoma:  "fadcc2724242479f59b6a36ede101eff047852588d59ba3a3aa5d0128fc90d12"
    sha256 sonoma:        "b0e52a27dc75e276ce065ffc789459ca52f21dda227f55f2bf3751961d372a46"
    sha256 arm64_linux:   "6fc95d40253e2c051e1b89d37180de5fe43089ba5e94a9e192a7ac7e407a05eb"
    sha256 x86_64_linux:  "81da130e4d89d11f88fab2f85c15a549bae8efe01985ebc4633e3c893a48a9a1"
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
