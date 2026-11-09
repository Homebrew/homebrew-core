class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.7/proteinortho-v6.3.7.tar.gz"
  sha256 "9ebc51af7f9653a24d93cb930afebf4fbc3df5be088c121ddf56928556187830"
  license "GPL-3.0-or-later"

  depends_on "diamond"
  depends_on "openblas"

  on_macos do
    depends_on "libomp"
  end

  uses_from_macos "perl"

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/DBI-1.647.tgz"
    sha256 "0df16af8e5b3225a68b7b592ab531004ddb35a9682b50300ce50174ad867d9aa"
  end

  resource "DBD::SQLite" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/DBD-SQLite-1.78.tar.gz"
    sha256 "efbad7794bafaa4e7476c07445a33bbfe1040e380baa3395a02635eebe3859d5"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("DBI").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                     "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none"
      system "make", "install"
    end

    resource("DBD::SQLite").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                     "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none"
      system "make", "install"
    end

    ENV.cxx11

    # Enable OpenMP
    if OS.mac?
      ENV.append_to_cflags "-Xpreprocessor -fopenmp -I#{formula_opt_include("libomp")}"
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("libomp")} -lomp"
    end

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"

    # Make the bundled perl modules (DBI/DBD::SQLite) available at runtime
    libexec_perl5 = libexec/"lib/perl5"
    Dir[bin/"*.pl"].each do |script|
      inreplace script, "use strict;", "use strict;\nuse lib #{libexec_perl5.to_s.dump};"
    end

    doc.install "manual.html"
    pkgshare.install "test"
  end

  test do
    system "perl", "-MDBI", "-MDBD::SQLite", "-e", "1"
    system bin/"proteinortho", "-test"
    system bin/"proteinortho_clustering", "-test"

    # This test exercises OpenMP
    cp_r pkgshare/"test", testpath
    files = Dir[testpath/"test/*.faa"]
    system bin/"proteinortho", *files
  end
end
