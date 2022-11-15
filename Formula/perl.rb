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
    sha256 arm64_ventura:  "060d846955f6c1263f550709f425b02b232a9f61adc755af6a4749fac8250f13"
    sha256 arm64_monterey: "aef200b8035eb1fbf5b6aa219c053df7f73d9c07da10f503f08889ae70e2e92a"
    sha256 arm64_big_sur:  "f0f893e0ceb2e9855bfcec2ceafaaaa8202df3477d11f39b88722eb776ee4f34"
    sha256 ventura:        "5363b1a09291d6e4b4d87b263f3692b535e1426192bf13cca62264f0ea34e807"
    sha256 monterey:       "5b63dfe448c0b7a69cb8a3d0b4220074848ae0680a2f245080a8f4cfd1be3baf"
    sha256 big_sur:        "b8371ca58bdc89bd17ba3bd0a0f6d151fb0bbd1544e47357ad474507f4ca5f28"
    sha256 catalina:       "3f0a9bae1a11de46f3cb19e9f1d64e63b6af957a771bcab0663ab18f2a6822b3"
    sha256 x86_64_linux:   "64131980cdcecfdee05b10ab5878f3152f6f661fd779358b4d658d7d23f36d36"
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
