class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.7/proteinortho-v6.3.7.tar.gz"
  sha256 "9ebc51af7f9653a24d93cb930afebf4fbc3df5be088c121ddf56928556187830"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "da693ce66b7938528e06d7a449d8d76f7e9ae628c6c650b1aa5b83fb2a1af382"
    sha256 cellar: :any, arm64_tahoe:       "f03983fbc6739867d30c9d7762c0ef26a8b7de5d80c2559b88ab690df7d0312e"
    sha256 cellar: :any, arm64_sequoia:     "65a313e433ceeedb616cdaff5c78371bf09e017ff8fc894dd37515d875ed0f58"
    sha256 cellar: :any, arm64_linux:       "86a0133fdf7518970a0a64298282ec534d9c1487db0cfbb5ab6f10406fd7a83b"
    sha256 cellar: :any, x86_64_linux:      "5d8a81a029a52e80a455af92c6b7206e040ad614beb966e55bb441a9f7694a93"
  end

  depends_on "diamond"
  depends_on "openblas"

  uses_from_macos "perl"

  on_macos do
    depends_on "libomp"
  end

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

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                       "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none"
        system "make"
        system "make", "install"
      end
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
    ([bin/"proteinortho"] + Dir[bin/"*.pl"]).each do |script|
      inreplace script, /\A#!.*$/, "\\0\nuse lib #{libexec_perl5.to_s.dump};"
    end

    doc.install "manual.html"
    pkgshare.install "test"
  end

  test do
    system "perl", "-I#{libexec}/lib/perl5", "-MDBI", "-MDBD::SQLite", "-e", "1"
    system bin/"proteinortho", "-test"
    system bin/"proteinortho_clustering", "-test"

    # This test exercises OpenMP
    cp_r pkgshare/"test", testpath
    files = Dir[testpath/"test/*.faa"]
    system bin/"proteinortho", *files
  end
end
