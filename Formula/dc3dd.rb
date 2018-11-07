class Dc3dd < Formula
  desc "Patched GNU dd that is intended for forensic acquisition of data"
  homepage "https://sourceforge.net/projects/dc3dd/"
  url "https://downloads.sourceforge.net/project/dc3dd/dc3dd/7.2.646/dc3dd%207.2.646/dc3dd-7.2.646.zip",
      :using => :nounzip
  sha256 "c4e325e5cbdae49e3855b0849ea62fed17d553428724745cea53fe6d91fd2b7f"
  revision 1

  bottle do
    rebuild 1
    sha256 "91be6d42e350b7af3ae449044fd7ab6d5a78253e8e217578b90065c99a5b15f4" => :mojave
    sha256 "42eadd524bba6cd7f4d4898f209aafd3aca03522d2dad45af7ede5262dbbb009" => :high_sierra
    sha256 "bf191ae1f00552deaf5c966367cfca182d98ab6e84e284d06be62da8f517f2eb" => :sierra
  end

  depends_on "gettext"

  resource "gettext-pm" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
    # Regular zip files created by 7-zip can upset /usr/bin/unzip by reporting a
    # non-zero size for dirs. Work around this.
    # Reported 32 Oct 2016 https://sourceforge.net/p/dc3dd/bugs/14/
    system "unzip dc3dd-#{version}.zip ; true"

    cd "dc3dd-#{version}" do
      ENV.prepend_create_path "PERL5LIB", buildpath/"gettext-pm/lib/perl5"
      resource("gettext-pm").stage do
        inreplace "Makefile.PL", "$libs = \"-lintl\"",
                                 "$libs = \"-L/usr/local/opt/gettext/lib -lintl\""
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}/gettext-pm"
        system "make"
        system "make", "install"
      end

      # Fixes error: 'Illegal instruction: 4'; '%n used in a non-immutable format string' on 10.13
      # Patch comes from gnulib upstream (see https://sourceforge.net/p/dc3dd/bugs/17/)
      inreplace "lib/vasnprintf.c",
                "# if !(__GLIBC__ > 2 || (__GLIBC__ == 2 && __GLIBC_MINOR__ >= 3) || ((defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__))",
                "# if !(defined __APPLE__ && defined __MACH__)"

      chmod 0555, ["build-aux/install-sh", "configure"]

      args = %W[--disable-debug
                --disable-dependency-tracking
                --prefix=#{prefix}
                --infodir=#{info}]

      # Check for stpncpy is broken, and the replacement fails to compile
      # on Lion and newer; see https://github.com/Homebrew/homebrew/issues/21510
      args << "gl_cv_func_stpncpy=yes" if MacOS.version >= :lion
      system "./configure", *args
      system "make"
      system "make", "install"
      prefix.install %w[Options_Reference.txt Sample_Commands.txt]
    end
  end

  test do
    system bin/"dc3dd", "--help"
  end
end
