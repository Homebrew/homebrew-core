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
    rebuild 1
    sha256 arm64_tahoe:   "11266b9a2528911df242d82ec041ee91a50c3374d03c9401b558e521b5569916"
    sha256 arm64_sequoia: "055da0dbe11d31788f13154fb01f7b5596e8450705bd4a1e54e799977d7bddaa"
    sha256 arm64_sonoma:  "e9270cae03ec248b9910b33924cd522773d4494ed1da07a4fbc8bc70c48eeddd"
    sha256 sonoma:        "78ee0a26f6650a15d49bc1e6586b91f9716981207059d511704d15f30882c63a"
    sha256 arm64_linux:   "a2adf29ff516a10c5851c1da904cb033cb92f89c5ea8efee5600065d06f3d989"
    sha256 x86_64_linux:  "036d3e8899b33c3c4f7dd9b69057f5dd522184a72750b212376d8fd5fc7d120f"
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
