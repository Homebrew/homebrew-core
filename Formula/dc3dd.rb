class Dc3dd < Formula
  desc "Patched GNU dd that is intended for forensic acquisition of data"
  homepage "https://sourceforge.net/projects/dc3dd/"
  url "https://downloads.sourceforge.net/project/dc3dd/dc3dd/7.2.646/dc3dd%207.2.646/dc3dd-7.2.646.zip", using: :nounzip
  sha256 "c4e325e5cbdae49e3855b0849ea62fed17d553428724745cea53fe6d91fd2b7f"
  revision 2

  bottle do
    sha256 monterey:    "81691239ee28eea77448db74952f8f8f1595a6c09bb5924f0a092cf050ebbf17"
    sha256 big_sur:     "4b01295bd5bab46484c16fd08989ea81bb69711daa15696dee756f75323e9ed2"
    sha256 catalina:    "fdd027b6a694489b16d05eab760a88903a83add31033296b13bf660c5807ea12"
    sha256 mojave:      "da27e2227f7fac70c613c4677ec597255c13b1253bc7c79cf58f7321a0a6427e"
    sha256 high_sierra: "b906b2d7009282e22eb97a1ad07982f3e4545fa4791cb2bc2eaf1e0c101ebaed"
    sha256 sierra:      "581af2165e8c666a92060e8354107cd0b27ada0143b4e0f5416b1d76739f45b7"
  end

  depends_on "gettext"

  uses_from_macos "perl" => :build

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
                "# if !(__GLIBC__ > 2 || (__GLIBC__ == 2 && __GLIBC_MINOR__ >= 3) " \
                "|| ((defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__))",
                "# if !(defined __APPLE__ && defined __MACH__)"

      chmod 0555, ["build-aux/install-sh", "configure"]

      args = %W[
        --disable-debug
        --disable-dependency-tracking
        --prefix=#{prefix}
        --infodir=#{info}
        gl_cv_func_stpncpy=yes
      ]
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
