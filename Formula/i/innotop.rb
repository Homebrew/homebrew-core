class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "6ec91568e32bda3126661523d9917c7fbbd4b9f85db79224c01b2a740727a65c"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 9
  head "https://github.com/innotop/innotop.git"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e071814f6161dc4eaa06cf898fa9862706a1343b9bec56c90e579c181d5428b8"
    sha256 cellar: :any,                 arm64_sonoma:   "85d95a6535f9faee3b036381c8bbc025c00a3bcc11e2c347ba192bab5234c8b6"
    sha256 cellar: :any,                 arm64_ventura:  "4bf05ccc4fe1ac5987fb1168a42305582784f511649a8bc75d757b0eb5aaf6c1"
    sha256 cellar: :any,                 arm64_monterey: "b35348e6b4f2b95fb7f5ff02ca5fb36bacb2eddfd85e84109563c25d1769c743"
    sha256 cellar: :any,                 sonoma:         "7a66b736dd4226d3ad4f98627a1b7fb79cfeaa1f2cafa6826cea701ed3697b30"
    sha256 cellar: :any,                 ventura:        "d948152a68a84aa2e82d18d8b8b182bf206d161d0b5f9ff1482c2082fcf48a0d"
    sha256 cellar: :any,                 monterey:       "c5e9dfe2530c6c898db115ab583987749cd60f4a8d82726b6028c71076533e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8198b82e42c0544d11edc1e668830ec0c84af94efc06694c9390b901f49c15bf"
  end

  depends_on "mysql-client"
  depends_on "openssl@3"

  uses_from_macos "perl"

  on_macos do
    on_intel do
      depends_on "zstd"
    end

    depends_on "zlib"
  end

  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.008.tar.gz"
    sha256 "a2324566883b6538823c263ec8d7849b326414482a108e7650edc0bed55bcd89"
  end

  resource "Term::ReadKey" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    inreplace "innotop", "#!/usr/bin/env perl", "#!/usr/bin/perl"

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
