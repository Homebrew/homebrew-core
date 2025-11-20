class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/refs/tags/1.34.tar.gz"
  sha256 "50e90b18f2541aca857b8743bd3c187b7844c608076c4f2aa13eadc0689b1644"
  license any_of: ["Artistic-1.0", "GPL-1.0-or-later"]
  head "https://github.com/tokuhirom/perl-build.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63b299c6c373e14016ed4230f61d1ce8a6120f72d3665505e6948dd4b34590ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3692d7e9799089d15e95e238a8a666883db875b08aefd182ffb49069bfeee070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3692d7e9799089d15e95e238a8a666883db875b08aefd182ffb49069bfeee070"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29f8fbb44085bb547f8a743c7c901f7ab1cd0bb571bb37a80241c874630182ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3c90eb8a0abf4173cc6109f072a647a096e4c038db4384def5e91ed771abfbd"
    sha256 cellar: :any_skip_relocation, ventura:       "74110bb18dd37b2a407cdcbd7772900d0751740a087bd2b86ee8354b92d9a71b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5671351addb7d9c47ae0e7f7cc5a11eabb9532e0d07021dab6cd18548bc385e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa96b05a3ea3bfa998356d31fd7719d938aa9554aae4a72b925b6a68f11db11"
  end

  uses_from_macos "perl"

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.045.tar.gz"
    sha256 "d20692eee246d0b329b7f7659f36286b14ae0696fe91078a64b7078f8876d300"
  end

  resource "ExtUtils::Config" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.008.tar.gz"
    sha256 "ae5104f634650dce8a79b7ed13fb59d67a39c213a6776cfdaa3ee749e62f1a8c"
  end

  resource "ExtUtils::Helpers" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.026.tar.gz"
    sha256 "de901b6790a4557cf4ec908149e035783b125bf115eb9640feb1bc1c24c33416"
  end

  resource "ExtUtils::InstallPaths" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.012.tar.gz"
    sha256 "84735e3037bab1fdffa3c2508567ad412a785c91599db3c12593a50a1dd434ed"
  end

  resource "HTTP::Tinyish" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/HTTP-Tinyish-0.18.tar.gz"
    sha256 "80380b8d33c6bfa96bb0104fa6a41c27dcc4e9c83a48df1fad39097f5fdcfde5"
  end

  resource "CPAN::Perl::Releases" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/CPAN-Perl-Releases-5.20230423.tar.gz"
    sha256 "c2eda421ed14ba0feffea6748f344b7ee3c364aefce4d15a1450e06861760fea"
  end

  resource "CPAN::Perl::Releases::MetaCPAN" do
    url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/CPAN-Perl-Releases-MetaCPAN-0.006.tar.gz"
    sha256 "d78ef4ee4f0bc6d95c38bbcb0d2af81cf59a31bde979431c1b54ec50d71d0e1b"
  end

  resource "File::pushd" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-pushd-1.016.tar.gz"
    sha256 "d73a7f09442983b098260df3df7a832a5f660773a313ca273fa8b56665f97cdc"
  end

  resource "HTTP::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/HTTP-Tiny-0.082.tar.gz"
    sha256 "54e9e4a559a92cbb90e3f19c8a88ff067ec2f68fbe39bbb694ee70828cd5f4b8"
  end

  resource "Module::Pluggable" do
    url "https://cpan.metacpan.org/authors/id/S/SI/SIMONW/Module-Pluggable-5.2.tar.gz"
    sha256 "b3f2ad45e4fd10b3fb90d912d78d8b795ab295480db56dc64e86b9fa75c5a6df"
  end

  resource "Devel::PatchPerl" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Devel-PatchPerl-2.08.tar.gz"
    sha256 "69c6e97016260f408e9d7e448f942b36a6d49df5af07340f1d65d7e230167419"
  end

  resource "Pod::Text" do
    url "https://cpan.metacpan.org/authors/id/R/RR/RRA/podlators-5.01.tar.gz"
    sha256 "ccfd1df9f1a47f095bce6d718fad5af40f78ce2491f2c7239626e15b7020bc71"
  end

  resource "Pod::Usage" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Usage-2.03.tar.gz"
    sha256 "7d8fdc7dce60087b6cf9e493b8d6ae84a5ab4c0608a806a6d395cc6557460744"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # Ensure we don't install the pre-packed script
    rm(["perl-build", "bin/perl-build"])

    build_pl = ["Module::Build::Tiny", "CPAN::Perl::Releases::MetaCPAN"]
    resources.each do |r|
      r.stage do
        next if build_pl.include? r.name

        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    build_pl.each do |name|
      resource(name).stage do
        system "perl", "Build.PL", "--install_base", libexec
        system "./Build"
        system "./Build", "install"
      end
    end

    system "perl", "Build.PL", "--install_base", libexec, "--install_path", "bindoc=#{man1}"
    # Replace the dead symlink we removed earlier.
    (buildpath/"bin").install_symlink buildpath/"script/perl-build"
    system "./Build"
    system "./Build", "install"

    bin.install libexec/"bin/plenv-install", libexec/"bin/plenv-uninstall"
    (bin/"perl-build").write_env_script(libexec/"bin/perl-build", PERL5LIB: ENV["PERL5LIB"])

    # Replace cellar path to perl with opt path.
    if OS.linux?
      inreplace_files = [libexec/"bin/perl-build", libexec/"bin/config_data"]
      inreplace inreplace_files, Formula["perl"].bin.realpath, Formula["perl"].opt_bin, global: false
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/perl-build --version")
  end
end
