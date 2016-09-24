class Imapsync < Formula
  desc "Migrate or backup IMAP mail accounts"
  homepage "http://ks.lamiral.info/imapsync/"
  url "https://fedorahosted.org/released/imapsync/imapsync-1.684.tgz"
  sha256 "ab4409c50949fc829bc212d7d9a4919dcafd3ccc55bce6e4e5b11bb8946a98c6"

  head "https://git.fedorahosted.org/git/imapsync.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de7c53f4c18f035175da75439b53b718c27a552caefb9ee92ddc1c6b486499a4" => :el_capitan
    sha256 "186f5bbde3fb0f3bd2c9693afba70e0f4f516ecf9ecaa8dbaa5f5c656073776d" => :yosemite
    sha256 "1578a665064fa52622cd86f26109185790ca833899de1ee54da89610221f4d77" => :mavericks
  end

  resource "Unicode::String" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Unicode-String-2.09.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/Unicode-String-2.09.tar.gz"
    sha256 "c817bedb954ea2d488bade56059028b99e0198f6826482e2f68fd6d78653faad"
  end

  resource "File::Copy::Recursive" do
    url "https://cpan.metacpan.org/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.38.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.38.tar.gz"
    sha256 "84ccbddf3894a88a2c2b6be68ff6ef8960037803bb36aa228b31944cfdf6deeb"
  end

  resource "Mail::IMAPClient" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.38.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.38.tar.gz"
    sha256 "d0f346d111dba93548ceac1192a993210ffcd5f81f83638ee277607bfacc1a4d"
  end

  resource "Authen::NTLM" do
    url "https://cpan.metacpan.org/authors/id/N/NB/NBEBOUT/NTLM-1.09.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/N/NB/NBEBOUT/NTLM-1.09.tar.gz"
    sha256 "c823e30cda76bc15636e584302c960e2b5eeef9517c2448f7454498893151f85"
  end

  resource "IO::Tee" do
    url "https://cpan.metacpan.org/authors/id/K/KE/KENSHAN/IO-Tee-0.64.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/K/KE/KENSHAN/IO-Tee-0.64.tar.gz"
    sha256 "3ed276b1c2d3511338653c2532e73753d284943c1a8f5159ff37fecc2b345ed6"
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

    system "perl", "-c", "imapsync"
    system "pod2man", "imapsync", "imapsync.1"
    bin.install "imapsync"
    man1.install "imapsync.1"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    output = shell_output("#{bin}/imapsync --dry", 2)
    assert_match version.to_s, output
    resources.each do |r|
      assert_match /#{r.name}\s+#{r.version}/, output
    end
  end
end
