class Pgtap < Formula
  desc "Unit testing framework for PostgreSQL"
  homepage "http://pgtap.org/"
  url "http://api.pgxn.org/dist/pgtap/0.96.0/pgtap-0.96.0.zip"
  sha256 "84ad5e2212555077393d74b4628b9cbd141b1f382e7b7f39662ffe64e3fa2521"
  revision 1

  head "https://github.com/theory/pgtap.git"

  bottle do
    cellar :any
    sha256 "cdc7061668561266d6e4f3af7b1edeabced55a4b916fb05a01839783e8b8c016" => :el_capitan
    sha256 "adeffa3e59f69e34e637815eeed7e52277550bfb41b4303c0ae0f62b28d35a31" => :yosemite
    sha256 "2da98046f27fc92f0a652004557609132fb8aa50a18e994d0071aac736eaac3f" => :mavericks
  end

  # Not :postgresql, because we need to install into its share directory.
  depends_on "postgresql"

  resource "Test::Harness" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.36.tar.gz"
    sha256 "e7566f13b041d028b56f184b77ec2545ec6f0bb5a0f8f5368f7e4a08b496b63e"
  end

  resource "TAP::Parser::SourceHandler::pgTAP" do
    url "https://cpan.metacpan.org/authors/id/D/DW/DWHEELER/TAP-Parser-SourceHandler-pgTAP-3.31.tar.gz"
    sha256 "d4ea61d77f486df52d0bc15026862d01ad50d21c8e008f3c2060bd7a9127bfe9"
  end

  resource "DBD::Pg" do
    url "https://cpan.metacpan.org/authors/id/T/TU/TURNSTEP/DBD-Pg-3.5.3.tar.gz"
    sha256 "7e98a9b975256a4733db1c0e974cad5ad5cb821489323e395ed97bd058e0a90e"
  end

  def install
    # Make sure modules can find just-installed dependencies.
    arch = `perl -MConfig -E 'print $Config{archname}'`
    plib = "#{lib}/perl5"
    ENV["PERL5LIB"] = "#{plib}:#{plib}/#{arch}:#{lib}:#{lib}/#{arch}"

    resource("Test::Harness").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
             "INSTALLSITEMAN1DIR=#{man1}", "INSTALLSITEMAN3DIR=#{man3}"
      system "make"
      system "make", "install"
    end

    resource("TAP::Parser::SourceHandler::pgTAP").stage do
      system "perl", "Build.PL", "--install_base", prefix, "--install_path",
             "bindoc=#{man1}", "--install_path", "libdoc=#{man3}"
      system "./Build"
      system "./Build", "install"
    end

    resource("DBD::Pg").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
             "INSTALLSITEMAN3DIR=#{man3}"
      system "make"
      system "make", "install"
    end

    pg_config = "#{Formula["postgresql"].opt_bin}/pg_config"
    mkdir "stage"
    system "make", "PG_CONFIG=#{pg_config}"

    system "make", "install", "DESTDIR=#{buildpath}/stage"
    (doc/"postgresql/extension").install Dir["stage/**/share/doc/postgresql/extension/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    # This is a bit of a "fake" test but it allows us to check the Perl env
    # has been configured correctly and the tools have basic functionality.
    system "#{Formula["postgresql"].opt_bin}/initdb", testpath/"test"
    system bin/"pg_prove", testpath/"test"
  end
end
