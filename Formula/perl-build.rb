class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/1.33.tar.gz"
  sha256 "79cfe7cdad693ab7b5a9544b81cff43c5ee7d09c057c86af524395313d53759b"
  license any_of: ["Artistic-1.0", "GPL-1.0-or-later"]
  revision 1
  head "https://github.com/tokuhirom/perl-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d9608da782685ddfb59db4495bec0eaaf9a2dd1626a83996c45c97bd12e2354"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d9608da782685ddfb59db4495bec0eaaf9a2dd1626a83996c45c97bd12e2354"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "558af15f28cb87935cda530e36419a86a843b15507c502e83de36ddf6549d75c"
    sha256 cellar: :any_skip_relocation, ventura:        "2bfab1553d4dd92516f1047494f7cf5dc18929bf2d55db241d01cf4957c90059"
    sha256 cellar: :any_skip_relocation, monterey:       "2bfab1553d4dd92516f1047494f7cf5dc18929bf2d55db241d01cf4957c90059"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6cde594d2cc9c52a19a46e4dbd874ade410ef6972a52e39ca92cdbe32edd33c"
    sha256 cellar: :any_skip_relocation, catalina:       "4edfe560c51cd7bbfc534d902f25073ea977e2fd145cb135872ef60020860b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7d90c53829a1270a2a5bcddc11a53aef64e130f6198cadbbe0046dc605ce87"
  end

  uses_from_macos "perl"

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
    sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
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
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/HTTP-Tinyish-0.17.tar.gz"
    sha256 "47bd111e474566d733c41870e2374c81689db5e0b5a43adc48adb665d89fb067"
  end

  resource "CPAN::Perl::Releases" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/CPAN-Perl-Releases-5.20210220.tar.gz"
    sha256 "c88ba6bba670bfc36bcb10adcceab83428ab3b3363ac9bb11f374a88f52466be"
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
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Devel-PatchPerl-2.08.tar.gz"
    sha256 "69c6e97016260f408e9d7e448f942b36a6d49df5af07340f1d65d7e230167419"
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
