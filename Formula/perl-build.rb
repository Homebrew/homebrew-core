class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/1.27.tar.gz"
  sha256 "10bb9e30d775ce08bf66c2bd2ea24b5ee5f3ee956d0fba127dba385abc53556f"
  head "https://github.com/tokuhirom/perl-build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "334d758431276eab85dedb6d85f49ba231cbf6f1403a924ee09bbe036c97778b" => :high_sierra
    sha256 "db1311750f48a2bd5cb8571f4dc7688c59b510855ca5481f65d57042cbdfc883" => :sierra
    sha256 "fd55b31409de788975a6118a73786b845a131e944edc8cf41877c5eea21044bf" => :el_capitan
  end

  resource "inc::latest" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/inc-latest-0.500.tar.gz"
    sha256 "daa905f363c6a748deb7c408473870563fcac79b9e3e95b26e130a4a8dc3c611"
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4224.tar.gz"
    sha256 "a6ca15d78244a7b50fdbf27f85c85f4035aa799ce7dd018a0d98b358ef7bc782"
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

  # Perl::Strip dependency
  resource "common::sense" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/common-sense-3.74.tar.gz"
    sha256 "771f7d02abd1ded94d9e37d3f66e795c8d2026d04defbeb5b679ca058116bbf3"
  end

  resource "Perl::Strip" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/Perl-Strip-1.1.tar.gz"
    sha256 "38030abf96af7d8080157ea42ede8564565cc0de4e7689dd8f85d824b4f54142"
  end

  resource "App::FatPacker" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSTROUT/App-FatPacker-0.010007.tar.gz"
    sha256 "d1158202cae6052385e8c7b1e5874992f5c2c5d85ef40894dcedbce6927336bd"
  end

  resource "CPAN::Perl::Releases" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/CPAN-Perl-Releases-3.76.tar.gz"
    sha256 "12aa472345597295a571e89b2c20ff0b58a647db1ea938b263263a2dd2b22a5d"
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

  # Devel::PatchPerl dependencies
  resource "IO::File" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IO-1.39.tar.gz"
    sha256 "4f0502e7f123ac824188eb8873038aaf2ddcc29f8babc1a0b2e1cd34b55a1fca"
  end

  resource "MIME::Base64" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/MIME-Base64-3.15.tar.gz"
    sha256 "7f863566a6a9cb93eda93beadb77d9aa04b9304d769cea3bb921b9a91b3a1eb9"
  end

  resource "XSLoader" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SAPER/XSLoader-0.24.tar.gz"
    sha256 "e819a35a6b8e55cb61b290159861f0dc00fe9d8c4f54578eb24f612d45c8d85f"
  end

  resource "Module::Pluggable" do
    url "https://cpan.metacpan.org/authors/id/S/SI/SIMONW/Module-Pluggable-5.2.tar.gz"
    sha256 "b3f2ad45e4fd10b3fb90d912d78d8b795ab295480db56dc64e86b9fa75c5a6df"
  end

  resource "Exporter" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/Exporter-5.73.tar.gz"
    sha256 "c5b6e96b0bda7af81c6b444171045cc614fd1f409358ebc810d55f053c8dcde9"
  end

  resource "Carp" do
    url "https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/Carp-1.50.tar.gz"
    sha256 "f5273b4e1a6d51b22996c48cb3a3cbc72fd456c4038f5c20b127e2d4bcbcebd9"
  end

  resource "ExtUtils::MakeMaker" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.34.tar.gz"
    sha256 "95f1eb44de480d00b28d031b574ec868f7aeeee199eb5abe5666f6bcbbf68480"
  end

  resource "Data::Dumper" do
    url "https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/Data-Dumper-2.172.tar.gz"
    sha256 "a95a3037163817221021ac145500968be44dc155c261f4097136392c0a9fecd9"
  end

  resource "Encode" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DANKOGAI/Encode-2.98.tar.gz"
    sha256 "303d396477c94c43c2f83da1a8025d68de76bd7e52c2cc35fbdf5c59b4c2cffa"
  end

  resource "parent" do
    url "https://cpan.metacpan.org/authors/id/C/CO/CORION/parent-0.237.tar.gz"
    sha256 "1089d9648565c1d1e655fa4cb603272d3126747b7b5f836ffee685e27e53caae"
  end

  resource "PathTools" do
    url "https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/PathTools-3.75.tar.gz"
    sha256 "a558503aa6b1f8c727c0073339081a77888606aa701ada1ad62dd9d8c3f945a2"
  end

  resource "Scalar-List-Utils" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.50.tar.gz"
    sha256 "06aab9c693380190e53be09be7daed20c5d6278f71956989c24cca7782013675"
  end

  resource "if" do
    url "https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/if-0.0608.tar.gz"
    sha256 "37206e10919c4d99273020008a3581bf0947d364e859b8966521c3145b4b3700"
  end

  # end of Devel::PatchPerl dependencies

  resource "Devel::PatchPerl" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Devel-PatchPerl-1.52.tar.gz"
    sha256 "4e69fb6f5f3add09915e6252ed6b3ff96f5ba60feb816e1aca2dfafef4c0d647"
  end

  resource "File::Temp" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-Temp-0.2308.tar.gz"
    sha256 "1ca1cb22e2ab1592e864b17c861113b5960e54d398726befc90559fb8df8d1d4"
  end

  resource "Getopt::Long" do
    url "https://cpan.metacpan.org/authors/id/J/JV/JV/Getopt-Long-2.49.1.tar.gz"
    sha256 "98fad4235509aa24608d9ef895b5c60fe2acd2bca70ebdf1acaf6824e17a882f"
  end

  # Pod::Usage dependency
  resource "Pod::Text" do
    url "https://cpan.metacpan.org/authors/id/R/RR/RRA/podlators-4.11.tar.gz"
    sha256 "5cad029e30a32a3dcde190fbb01399867432a31e8483c12eecfdbf36748fe2b0"
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
