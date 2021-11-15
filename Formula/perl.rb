class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.34.0.tar.xz"
  sha256 "82c2e5e5c71b0e10487a80d79140469ab1f8056349ca8545140a224dbbed7ded"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/perl/perl5.git", branch: "blead"

  livecheck do
    url "https://www.cpan.org/src/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4c53f42a2177a516381cf2cddde7cfaffecef66910af74379cbc10901779153f"
    sha256 arm64_big_sur:  "8b55cc95c9de8bdcf628ae6d6f631057952fa8b0218da8ac61eafe4da65a8761"
    sha256 monterey:       "dca9e216941d2c39b8222a49d4f3434d9773de6f9b4517b2fc148b221cf5e23c"
    sha256 big_sur:        "5f86afbccd065524f92080bd7f35ffe6398b7dd40a8fef6f0a2a7982fd276dae"
    sha256 catalina:       "de0127c56612bbadc3621217b586571cab897c001344b7a1d63302a4f8f74a8e"
    sha256 mojave:         "2222c3f09bdcd10640720d2f52ba71e09408ead129bc77853b2fdf88fc381061"
    sha256 x86_64_linux:   "cfd7c32f4076b6d9fbfb894bb6dc30cb14305a13e9b0fee93cd9b1ec2a768c92"
  end

  depends_on "berkeley-db"
  depends_on "gdbm"

  uses_from_macos "expat"

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  def install
    args = %W[
      -des
      -Dprefix=#{prefix}
      -Dprivlib=#{lib}/perl5/#{version}
      -Dsitelib=#{lib}/perl5/site_perl/#{version}
      -Dotherlibdirs=#{HOMEBREW_PREFIX}/lib/perl5/site_perl/#{version}
      -Dperlpath=#{opt_bin}/perl
      -Dstartperl=#!#{opt_bin}/perl
      -Dman1dir=#{man1}
      -Dman3dir=#{man3}
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]
    args << "-Dsed=/usr/bin/sed" if OS.mac?

    args << "-Dusedevel" if build.head?

    system "./Configure", *args

    system "make"

    system "make", "install"
  end

  def post_install
    if OS.linux?
      perl_archlib = Utils.safe_popen_read("perl", "-MConfig", "-e", "print $Config{archlib}")
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
