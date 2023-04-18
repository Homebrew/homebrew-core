class Dc3dd < Formula
  desc "Patched GNU dd that is intended for forensic acquisition of data"
  homepage "https://sourceforge.net/projects/dc3dd/"
  url "https://downloads.sourceforge.net/project/dc3dd/dc3dd/7.3.0/dc3dd-7.3.0.zip"
  sha256 "ec56b9551aec581322acaf3f557e0a6604d547de8a739374668e2f5af2053c3f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "9c79696dbf8e926a5183c46af958480fbb540aadef1cd2de77c633e7de416be0"
    sha256 arm64_monterey: "f0e8d052797b5d7f6cceaff9333b667e5a097c431211c38fbeb503291b282944"
    sha256 arm64_big_sur:  "76a28537261ac0d42152987b502bf33740912f8c2c4591d7dd4b718c812817ea"
    sha256 ventura:        "87e8290407b91dc241e9fe3469997e18ce83c3b0200ec91e882ba3523e9ac720"
    sha256 monterey:       "39000c17ca83c009a228e0c3e9e8c12f216b86d14edb9cd22600583c01f7eb9d"
    sha256 big_sur:        "9edb4701637373330d394a78c9c7a1b2db92cf129040021e21f37c0cf201cd1f"
    sha256 x86_64_linux:   "1b05f3886861e0ff5a15cb08f4697a6d56fca4242f5bfa271a305bcd7b6ae916"
  end

  depends_on "gettext"

  uses_from_macos "perl" => :build

  resource "gettext-pm" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath/"gettext-pm/lib/perl5"
    resource("gettext-pm").stage do
      inreplace "Makefile.PL", "$libs = \"-lintl\"",
                               "$libs = \"-L#{Formula["gettext"].opt_lib} -lintl\""
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

  test do
    system bin/"dc3dd", "--help"
  end
end
