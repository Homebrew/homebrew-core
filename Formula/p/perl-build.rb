class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/refs/tags/1.34.tar.gz"
  sha256 "50e90b18f2541aca857b8743bd3c187b7844c608076c4f2aa13eadc0689b1644"
  license any_of: ["Artistic-1.0", "GPL-1.0-or-later"]
  head "https://github.com/tokuhirom/perl-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "65330f996da4878f2231c9302be2910c484c4f1c2a4f979a90a931b480bd8a54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fab20ad3803975d872a837b0094e104a76b477b50358ebc858761609cd95b94a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88242c3173ebedeb662528ee8d076253fbe18c189cdef42768efc5e377bec466"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88242c3173ebedeb662528ee8d076253fbe18c189cdef42768efc5e377bec466"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18c043e60df07f020af0785e1f6dcad1ad1b3782e8f596efb8a5363c78669ccb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5a97a22ee550507bb8fc07353054a1c3eb8923a01ac5ad9510ba940b5089afc"
    sha256 cellar: :any_skip_relocation, ventura:        "9c09caf60e490235fc8366f3d47d32d8be9cf887d71cc3f80213700ef3443a65"
    sha256 cellar: :any_skip_relocation, monterey:       "9c09caf60e490235fc8366f3d47d32d8be9cf887d71cc3f80213700ef3443a65"
    sha256 cellar: :any_skip_relocation, big_sur:        "8699ea1e8465d1906944894a63767c339312afe64a850620dea4f0e2f05f3017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ad390432ffb57a2afbb7884722b2539fdd4a9951074eb88c06488d943eb348"
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
    (buildpath/"perl-build").unlink
    # Remove this apparently dead symlink.
    (buildpath/"bin/perl-build").unlink

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

    ENV.prepend_path "PATH", libexec/"bin"
    system "perl", "Build.PL", "--install_base", libexec
    # Replace the dead symlink we removed earlier.
    (buildpath/"bin").install_symlink buildpath/"script/perl-build"
    system "./Build"
    system "./Build", "install"

    %w[perl-build plenv-install plenv-uninstall].each do |cmd|
      (bin/cmd).write_env_script(libexec/"bin/#{cmd}", PERL5LIB: ENV["PERL5LIB"])
    end

    # Replace cellar path to perl with opt path.
    if OS.linux?
      inreplace Dir[libexec/"bin/{perl-build,config_data}"] do |s|
        s.sub! Formula["perl"].bin.realpath, Formula["perl"].opt_bin
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/perl-build --version")
  end
end
