class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/1.32.tar.gz"
  sha256 "ba86d74ff9718977637806ef650c85615534f0b17023a72f447587676d7f66fd"
  license any_of: ["Artistic-1.0", "GPL-1.0-or-later"]
  head "https://github.com/tokuhirom/perl-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9d4cdf8f97ae6c7aaafc8cb6e6d5099ec97f6ec0632a33af90e70766c9e497e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b662afe3c5e833e08c5e0a425f5597ab159b808e6285e90f96ee48e1f8d8d9a8"
    sha256 cellar: :any_skip_relocation, monterey:       "e05da78d5eab2ca95b3bdc567a1d8ef81d60c932af55420958f2e6538b18c89e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a24fadf986032226343c74378f0344b15729687d9b0679f64e859e41a4f165db"
    sha256 cellar: :any_skip_relocation, catalina:       "e2b99b05c34a89e8706810730e8ac6da7d98c76025b72d86eb2a6003a47a4b85"
    sha256 cellar: :any_skip_relocation, mojave:         "5ae631c827ab5b58f0e2bafa3b5470f3b2f2236802942c3d4454ab96fd212aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e55952e9cc4849a4a6da657c0b9e52f93da495518b9c0db1da64efab51ced28"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/perl-build --version")
  end
end
