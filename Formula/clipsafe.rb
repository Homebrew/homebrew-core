class Clipsafe < Formula
  desc "Command-line interface to Password Safe"
  homepage "https://waxandwane.org/clipsafe.html"
  url "https://waxandwane.org/download/clipsafe-1.1.tar.gz"
  sha256 "7a70b4f467094693a58814a42d272e98387916588c6337963fa7258bda7a3e48"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1a8a00c232a748d9b45271239043f5d155666acfdcb79670efc816e26c740221" => :catalina
    sha256 "c3c42621d02672ee0cabd443b871760320c1b82ba61b48bca61076acab10d097" => :mojave
    sha256 "211d670b61c6a68650736df3deb3ae783c320491ba3205e035cc28c014fca705" => :high_sierra
    sha256 "7c894e55e215fffa121aef718dbf7fa0f2c71531cf7970ae8d27f4b5eb939877" => :sierra
    sha256 "ffd255c6ff1bd4c403bc4040f1751eef61b4ae341c33b226bf9a696b2836b02e" => :el_capitan
    sha256 "01dbb7b4cf71ae2b174cfec45cdf4a69e211a5154bc6541fb19e1b5aa20f8389" => :yosemite
  end

  resource "Crypt::Twofish" do
    url "https://cpan.metacpan.org/authors/id/A/AM/AMS/Crypt-Twofish-2.17.tar.gz"
    sha256 "eed502012f0c63927a1a32e3154071cc81175d1992a893ec41f183b6e3e5d758"
  end

  resource "Digest::SHA" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSHELOR/Digest-SHA-5.96.tar.gz"
    sha256 "2b8e0a9b6e359d5e14159661647cc0fbde06beb7f2a24bf003f5fad0a3a2786a"
  end

  resource "DateTime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.35.tar.gz"
    sha256 "42da13b8b15373c1a1790ef4217742d34f7f80f7e5c51c377cc9eed3c7641525"
  end

  resource "DateTime::Locale" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.05.tar.gz"
    sha256 "692d674558589e2a6ad2d68cf58a6e4e4b1bfe2f7f76caf20cb91b975a51d155"
  end

  resource "DateTime::TimeZone" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.01.tar.gz"
    sha256 "1f673c8156fa42b2030aae46fd7e4c117f229da99dfbc7c57ef9eadd5eaa69e1"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("Crypt::Twofish").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("Digest::SHA").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("DateTime").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("DateTime::Locale").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("DateTime::TimeZone").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    bin.install "clipsafe"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"clipsafe", "--help"
  end
end
