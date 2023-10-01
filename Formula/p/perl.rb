class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/perl/perl5.git", branch: "blead"

  stable do
    url "https://www.cpan.org/src/5.0/perl-5.36.1.tar.xz"
    sha256 "bd91217ea8a8c8b81f21ebbb6cefdf0d13ae532013f944cdece2cd51aef4b6a7"

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
    sha256 arm64_sonoma:   "fe2cb6fbaec5532b9576656645d70da23b7156b033c6d568dc8b0284f2476756"
    sha256 arm64_ventura:  "95806fc97a4d19f592e9fc265e2a79a3183463306c41b665cea9f69d0d748d41"
    sha256 arm64_monterey: "4ab6b71b6068bf7efa35d9ec0c175b2de73917b9fe3bc2e47c25f4975c102c06"
    sha256 arm64_big_sur:  "6046f055d4e8c188726e73a5c6961618d6796c41b0f5b8ccbf874618fe546342"
    sha256 sonoma:         "f4df22e4172d25556c62361c1bdf93f63f565908866c6db27811d664ca7d4dcc"
    sha256 ventura:        "12a8c480c692775bf24c4ba802103982299e899c9d949ec4bc288ecab661a42d"
    sha256 monterey:       "624ccf8b182aabb60ec7bf1ded9177e4085253c53eab3cdecb30b694efc5ca97"
    sha256 big_sur:        "61baac39c1834ec0f7a026d639b6008eaf893090ebb57f947068e143e29ee556"
    sha256 x86_64_linux:   "db9590fceed0e461c2d01977d0d314f3d1696147dd1489c775e9ca415e2aee9a"
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
