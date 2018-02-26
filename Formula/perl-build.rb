class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/1.13.tar.gz"
  sha256 "921880b901ce8322577ae8004cb3214e1223f5ecef0553d02419e7aa265c76b8"
  head "https://github.com/tokuhirom/perl-build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eeb64fad11c3e0cf8b5a5df38e0fcdf6f7019047fbe80dd5cf81023245c069fe" => :high_sierra
    sha256 "bcfeb9326b4783d8fb60c0e9850854528677e5d81bf7c6863584bba9f27d52e0" => :sierra
    sha256 "a6a0f5a53f5755544ac0422288a7f163ca41a8a7f6747bc6564c3498dfae4320" => :el_capitan
    sha256 "5b52eb99f45233a8776170cb31fc0b1e9057b1c74e7e5d9ceddd8bad1460b61d" => :yosemite
  end

  # Perl::Strip dependency
  resource "common::sense" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/common-sense-3.74.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/ML/MLEHMANN/common-sense-3.74.tar.gz"
    sha256 "771f7d02abd1ded94d9e37d3f66e795c8d2026d04defbeb5b679ca058116bbf3"
  end

  resource "Perl::Strip" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/Perl-Strip-1.1.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/ML/MLEHMANN/Perl-Strip-1.1.tar.gz"
    sha256 "38030abf96af7d8080157ea42ede8564565cc0de4e7689dd8f85d824b4f54142"
  end

  resource "App::FatPacker" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSTROUT/App-FatPacker-0.010007.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MS/MSTROUT/App-FatPacker-0.010007.tar.gz"
    sha256 "d1158202cae6052385e8c7b1e5874992f5c2c5d85ef40894dcedbce6927336bd"
  end

  resource "CPAN::Perl::Releases" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/CPAN-Perl-Releases-3.14.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/B/BI/BINGOS/CPAN-Perl-Releases-3.14.tar.gz"
    sha256 "c27d718004adaa22c7f6f0ccb471237610c4fc1ed928306e9900e2bb0d20ab56"
  end

  resource "File::pushd" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-pushd-1.014.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DA/DAGOLDEN/File-pushd-1.014.tar.gz"
    sha256 "b5ab37ffe3acbec53efb7c77b4423a2c79afa30a48298e751b9ebee3fdc6340b"
  end

  resource "HTTP::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/HTTP-Tiny-0.070.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DA/DAGOLDEN/HTTP-Tiny-0.070.tar.gz"
    sha256 "74f385d1e96de887a4df5a222d93afdc7d81ea9ad721a56ff3d8449bb12f7733"
  end

  # Devel::PatchPerl dependencies
  resource "IO::File" do
    url "https://cpan.metacpan.org/authors/id/G/GB/GBARR/IO-1.25.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/G/GB/GBARR/IO-1.25.tar.gz"
    sha256 "89790db8b9281235dc995c1a85d532042ff68a90e1504abd39d463f05623e7b5"
  end

  resource "MIME::Base64" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/MIME-Base64-3.15.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/MIME-Base64-3.15.tar.gz"
    sha256 "7f863566a6a9cb93eda93beadb77d9aa04b9304d769cea3bb921b9a91b3a1eb9"
  end

  resource "XSLoader" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SAPER/XSLoader-0.24.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/S/SA/SAPER/XSLoader-0.24.tar.gz"
    sha256 "e819a35a6b8e55cb61b290159861f0dc00fe9d8c4f54578eb24f612d45c8d85f"
  end

  resource "Module::Pluggable" do
    url "https://cpan.metacpan.org/authors/id/S/SI/SIMONW/Module-Pluggable-5.2.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/S/SI/SIMONW/Module-Pluggable-5.2.tar.gz"
    sha256 "b3f2ad45e4fd10b3fb90d912d78d8b795ab295480db56dc64e86b9fa75c5a6df"
  end

  resource "Exporter" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/Exporter-5.72.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/Exporter-5.72.tar.gz"
    sha256 "cd13b7a0e91e8505a0ce4b25f40fab2c92bb28a99ef0d03da1001d95a32f0291"
  end

  resource "Carp" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Carp-1.38.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/Carp-1.38.tar.gz"
    sha256 "a5a9ce3cbb959dfefa8c2dd16552567199b286d39b0e55053ca247c038977101"
  end

  resource "ExtUtils::MakeMaker" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.24.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.24.tar.gz"
    sha256 "416abc97c3bb2cc72bef28852522f2859de53e37bf3d0ae8b292067d78755e69"
  end

  resource "Data::Dumper" do
    url "https://cpan.metacpan.org/authors/id/S/SM/SMUELLER/Data-Dumper-2.161.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/S/SM/SMUELLER/Data-Dumper-2.161.tar.gz"
    sha256 "3aa4ac1b042b3880438165fb2b2139d377564a8e9928ffe689ede5304ee90558"
  end

  resource "Encode" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DANKOGAI/Encode-2.89.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DA/DANKOGAI/Encode-2.89.tar.gz"
    sha256 "e6299e67bc7379117015fcff38ba09da37441046a7f16a63dbaaf48b5738fcb4"
  end

  resource "parent" do
    url "https://cpan.metacpan.org/authors/id/C/CO/CORION/parent-0.236.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CO/CORION/parent-0.236.tar.gz"
    sha256 "2d837ebd04f6aa4b8634c9fa9d0bead83f1bee4a8072defe862ee6eb82be127a"
  end

  resource "PathTools" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/PathTools-3.62.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/PathTools-3.62.tar.gz"
    sha256 "36350e12f58871437ba03391f80a506e447e3c6630cc37d0625bc25ff1c7b4d2"
  end

  resource "Scalar-List-Utils" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.47.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.47.tar.gz"
    sha256 "c483347372a96972d61fd186522a9dafc2da899ef2951964513b7e8efb37efe1"
  end

  resource "if" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/if-0.0606.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/R/RJ/RJBS/if-0.0606.tar.gz"
    sha256 "63d69282d6c4c9e76370b78d770ca720cea88cfe5ee5b612709240fc6078d50e"
  end

  # end of Devel::PatchPerl dependencies

  resource "Devel::PatchPerl" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Devel-PatchPerl-1.48.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/B/BI/BINGOS/Devel-PatchPerl-1.48.tar.gz"
    sha256 "26a9bc8e52af739384cece2773921dd44d2371b6cdf92fe452ecc348eb0d90fe"
  end

  resource "File::Temp" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-Temp-0.2304.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DA/DAGOLDEN/File-Temp-0.2304.tar.gz"
    sha256 "13415323e48f7c9f34efdedf3d35141a7c3435e2beb8c6b922229dc317d321ac"
  end

  resource "Getopt::Long" do
    url "https://cpan.metacpan.org/authors/id/J/JV/JV/Getopt-Long-2.49.1.tar.gz"
    sha256 "98fad4235509aa24608d9ef895b5c60fe2acd2bca70ebdf1acaf6824e17a882f"
  end

  # Pod::Usage dependency
  resource "Pod::Text" do
    url "https://cpan.metacpan.org/authors/id/R/RR/RRA/podlators-4.09.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/R/RR/RRA/podlators-4.09.tar.gz"
    sha256 "c86d9633487e47196bfea678622a042ac1c1f910d6f22a06ba4667239f2236ba"
  end

  resource "Pod::Usage" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Usage-1.69.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MA/MAREKR/Pod-Usage-1.69.tar.gz"
    sha256 "1a920c067b3c905b72291a76efcdf1935ba5423ab0187b9a5a63cfc930965132"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # Ensure we don't install the pre-packed script
    (buildpath/"perl-build").unlink

    inreplace "author/fatpack.sh" do |s|
      # We already set PERL5LIB above
      s.sub!(/^export PERL5LIB=.*$/, "")

      # Don't install anything
      s.gsub!(/^plenv .*$/, "")
      s.gsub!(/^cpanm .*$/, "")
    end

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV.prepend_path "PATH", libexec/"bin"
    system "bash", "-ex", "./author/fatpack.sh"

    bin.install "perl-build", "bin/plenv-install", "bin/plenv-uninstall"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/perl-build --version")
  end
end
