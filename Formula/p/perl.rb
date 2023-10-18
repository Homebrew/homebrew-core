class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/perl/perl5.git", branch: "blead"

  stable do
    url "https://www.cpan.org/src/5.0/perl-5.38.0.tar.xz"
    sha256 "eca551caec3bc549a4e590c0015003790bdd1a604ffe19cc78ee631d51f7072e"
  end

  livecheck do
    url "https://www.cpan.org/src/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d745ab0b23a4393bba2df3a83f45aca492ac4dbd725fbbd70f6da0630b04f3f3"
    sha256 arm64_ventura:  "a65fe1094e63104d7127c8d01b738bd22b17832137c81377740787d6386f7f92"
    sha256 arm64_monterey: "f0e0898c09cc63eb1d5385e101f3eb54253bddd85ebd8324044f027b443f1bef"
    sha256 sonoma:         "48c8d0446bd490a120355cac31a749392e460d4d8f1e69032ded567d5cf8c961"
    sha256 ventura:        "db18bcd07056234dce8a2ae8772f7e1decc78bcc2cbaaf578e3b6017ba83bd72"
    sha256 monterey:       "7acc87e52835adff7a89be9bd826c50839d591d881e0b6e935a416b179c38aa1"
    sha256 x86_64_linux:   "a2976adfb7e88f694ff6f570d47cf34b961a3c259fea71d720a8ad8fedd56266"
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
      And add the following to your shell profile e.g. ~/.profile or ~/.zshrc
        eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
