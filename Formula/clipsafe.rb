class Clipsafe < Formula
  desc "Command-line interface to Password Safe"
  homepage "http://waxandwane.org/clipsafe.html"
  url "http://waxandwane.org/download/clipsafe-1.1.tar.gz"
  sha256 "7a70b4f467094693a58814a42d272e98387916588c6337963fa7258bda7a3e48"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2284b60887b778596eda0b142d275b7344957863a94ac1aed3bb301e1366f91a" => :sierra
    sha256 "3763a17b2055d0ff696c05cf80f6811871e5851f8ca562536b207c66213ff336" => :el_capitan
    sha256 "dabbd01dd7dd7158d2964d7de98b1c55666adf7cf5143bcf1696ad6b1593fc24" => :yosemite
    sha256 "7ffe9cabd07551eba27db6bd00927a6653d71ebf8631186dc6b6876daa08a66b" => :mavericks
  end

  depends_on :macos => :mountain_lion

  resource "Crypt::Twofish" do
    url "https://cpan.metacpan.org/authors/id/A/AM/AMS/Crypt-Twofish-2.17.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/A/AM/AMS/Crypt-Twofish-2.17.tar.gz"
    sha256 "eed502012f0c63927a1a32e3154071cc81175d1992a893ec41f183b6e3e5d758"
  end

  resource "Digest::SHA" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSHELOR/Digest-SHA-5.96.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MS/MSHELOR/Digest-SHA-5.96.tar.gz"
    sha256 "2b8e0a9b6e359d5e14159661647cc0fbde06beb7f2a24bf003f5fad0a3a2786a"
  end

  resource "DateTime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.42.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DR/DROLSKY/DateTime-1.42.tar.gz"
    sha256 "efa4badf07365d1b03ee5527fc79baaf7d8b449bf7baad13599f04177232416e"
  end

  resource "namespace::autoclean" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/namespace-autoclean-0.28.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/E/ET/ETHER/namespace-autoclean-0.28.tar.gz"
    sha256 "cd410a1681add521a28805da2e138d44f0d542407b50999252a147e553c26c39"
  end

  resource "Specio" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.36.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DR/DROLSKY/Specio-0.36.tar.gz"
    sha256 "1399113b178dd9a2443f0e05bfd5bc665931442bf9e31b223893c7d2853c4480"
  end

  resource "Role::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.000005.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/H/HA/HAARG/Role-Tiny-2.000005.tar.gz"
    sha256 "593a29b621e029bf0218d0154d5dfdf6ec502afc49adeeadae6afd0c70063115"
  end

  resource "Sub::Identify" do
    url "https://cpan.metacpan.org/authors/id/R/RG/RGARCIA/Sub-Identify-0.12.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/R/RG/RGARCIA/Sub-Identify-0.12.tar.gz"
    sha256 "83bb785a66113b4a966db0a4186fd1dd07987acdacb4502b1e1558f817dde825"
  end

  resource "Params::ValidationCompiler" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.23.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.23.tar.gz"
    sha256 "e357b63e28950519f227a5b45e4ac1c487cbc6c1bb67c09a8d3698ee9f289230"
  end

  resource "Exception::Class" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Exception-Class-1.42.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DR/DROLSKY/Exception-Class-1.42.tar.gz"
    sha256 "8bb4ee64d3770d6812bda36890ef5df418573287eb8eccbb106f04c981dea22b"
  end

  resource "Devel::StackTrace" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.02.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.02.tar.gz"
    sha256 "cbbd96db0ecf194ed140198090eaea0e327d9a378a4aa15f9a34b3138a91931f"
  end

  resource "File::ShareDir::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.11.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/E/ET/ETHER/File-ShareDir-Install-0.11.tar.gz"
    sha256 "32bf8772e9fea60866074b27ff31ab5bc3f88972d61915e84cbbb98455e00cc8"
  end

  resource "DateTime::Locale" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.16.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DR/DROLSKY/DateTime-Locale-1.16.tar.gz"
    sha256 "dfaf4c42149c0622e80721773b8d7229d7785280503585895c9fe9f51e076cfe"
  end

  resource "File::ShareDir" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.102.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/R/RE/REHSACK/File-ShareDir-1.102.tar.gz"
    sha256 "7c7334b974882587fbd9bc135f6bc04ad197abe99e6f4761953fe9ca88c57411"
  end

  resource "DateTime::TimeZone" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.11.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.11.tar.gz"
    sha256 "a7c0b2581d2bf6d5cc535364099a67678a9f6ee608e5042dff9ef9c4c577ea6b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    bin.install "clipsafe"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"clipsafe", "--help"
  end
end
