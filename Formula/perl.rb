class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/perl/perl5.git", branch: "blead"

  stable do
    url "https://www.cpan.org/src/5.0/perl-5.36.0.tar.xz"
    sha256 "0f386dccbee8e26286404b2cca144e1005be65477979beb9b1ba272d4819bcf0"

    # Apply upstream commit to remove nsl from libswanted:
    # https://github.com/Perl/perl5/commit/7e19816aa8661ce0e984742e2df11dd20dcdff18
    # Remove with next tagged release that includes the change.
    patch do
      url "https://github.com/Perl/perl5/commit/7e19816aa8661ce0e984742e2df11dd20dcdff18.patch?full_index=1"
      sha256 "03f64cf62b9b519cefdf76a120a6e505cf9dc4add863b9ad795862c071b05613"
    end
  end

  livecheck do
    url "https://www.cpan.org/src/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "74b3f24c7c08a99b569e7d6159c68aa9912b222d7e4d40c9895436130fc1aba1"
    sha256 arm64_big_sur:  "c1edffa4e60b7c3801e1437e9bbf1d6a7eab0b77e9dd551a556dc9fd91b7dfcd"
    sha256 monterey:       "5baa007a4878f165e1e8f5fde45d8b670fc77043ff30458650513c37ddb4b495"
    sha256 big_sur:        "dc450ab3b43888382fcc46e975617a9c97f77ff5a6a690022f6745fd53ca8c72"
    sha256 catalina:       "34a5ce2d637952eb163fb9bac91767322971158106dcd88a44b7128d88bf050d"
    sha256 x86_64_linux:   "99dbd9c282ec8c2bdef461ff2c54b78d92ee19a315c69537b0f3aa420a4973ab"
  end

  depends_on "berkeley-db"
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

  def post_install
    if OS.linux?
      perl_archlib = Utils.safe_popen_read(bin/"perl", "-MConfig", "-e", "print $Config{archlib}")
      perl_core = Pathname.new(perl_archlib)/"CORE"
      if File.readlines("#{perl_core}/perl.h").grep(/include <xlocale.h>/).any? &&
         (OS::Linux::Glibc.system_version >= "2.26" ||
         (Formula["glibc"].any_version_installed? && Formula["glibc"].version >= "2.26"))
        # Glibc does not provide the xlocale.h file since version 2.26
        # Patch the perl.h file to be able to use perl on newer versions.
        # locale.h includes xlocale.h if the latter one exists
        inreplace "#{perl_core}/perl.h", "include <xlocale.h>", "include <locale.h>"
      end
    end
  end

  def caveats
    <<~EOS
      By default non-brewed cpan modules are installed to the Cellar. If you wish
      for your modules to persist across updates we recommend using `local::lib`.

      You can set that up like this:
        PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
        echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"' >> #{shell_profile}
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
