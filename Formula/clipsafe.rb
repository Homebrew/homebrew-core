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
    sha256 "eed502012f0c63927a1a32e3154071cc81175d1992a893ec41f183b6e3e5d758"
  end

  resource "Digest::SHA" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSHELOR/Digest-SHA-5.96.tar.gz"
    sha256 "2b8e0a9b6e359d5e14159661647cc0fbde06beb7f2a24bf003f5fad0a3a2786a"
  end

  resource "DateTime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.42.tar.gz"
    sha256 "efa4badf07365d1b03ee5527fc79baaf7d8b449bf7baad13599f04177232416e"
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
      system "perl", "Build.PL", "--install_base=#{libexec}"
      system "./Build"
      system "./Build", "install"
    end

    bin.install "clipsafe"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"clipsafe", "--help"
  end
end
