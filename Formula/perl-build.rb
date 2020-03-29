class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/1.30.tar.gz"
  sha256 "30585889bf7ba9979233d30cfd32686790833f0317ce8d796878dca996fab9bb"
  head "https://github.com/tokuhirom/perl-build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1f873c2ff9d0d82dc32342e4a048b0d766242128aa68c92c28b85e8ac7465ce" => :catalina
    sha256 "77795cc97a4a95805804fd05a9a73c3ee2e2fd807f032365d0bd7ebb57ae9117" => :mojave
    sha256 "6f32d771c449780efeca88dbb50f841ed15021053932958ce8bd6385a19b9f20" => :high_sierra
  end

  uses_from_macos "perl"

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4229.tar.gz"
    sha256 "1fe491a6cda914b01bc8e592faa2b5404e9f35915ca15322f8f2a8d8f9008c18"
  end

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz"
    sha256 "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c"
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
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/HTTP-Tinyish-0.15.tar.gz"
    sha256 "5d65f0ee20a9e4744acdb3ef12edae78c121f53dcbc9cf00867c5725c4513aa5"
  end

  resource "CPAN::Perl::Releases" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/CPAN-Perl-Releases-4.20.tar.gz"
    sha256 "71d3310531a644424be33f22148a582f892eb7b12555bc150dbdac4293abd8ed"
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
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/HTTP-Tiny-0.076.tar.gz"
    sha256 "ddbdaa2fb511339fa621a80021bf1b9733fddafc4fe0245f26c8b92171ef9387"
  end

  # Devel::PatchPerl dependency
  resource "Module::Pluggable" do
    url "https://cpan.metacpan.org/authors/id/S/SI/SIMONW/Module-Pluggable-5.2.tar.gz"
    sha256 "b3f2ad45e4fd10b3fb90d912d78d8b795ab295480db56dc64e86b9fa75c5a6df"
  end

  resource "Devel::PatchPerl" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Devel-PatchPerl-1.78.tar.gz"
    sha256 "93111a37ad7358ea5601444c2e76074b267ca84e4e6aca802547759ed74217e7"
  end

  # Pod::Usage dependency
  resource "Pod::Text" do
    url "https://cpan.metacpan.org/authors/id/R/RR/RRA/podlators-4.12.tar.gz"
    sha256 "948717da19630a5f003da4406da90fe1cbdec9ae493671c90dfb6d8b3d63b7eb"
  end

  resource "Pod::Usage" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Usage-1.69.tar.gz"
    sha256 "1a920c067b3c905b72291a76efcdf1935ba5423ab0187b9a5a63cfc930965132"
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
      (bin/cmd).write_env_script(libexec/"bin/#{cmd}", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/perl-build --version")
  end
end
