class Imapsync < Formula
  desc "Migrate or backup IMAP mail accounts"
  homepage "http://ks.lamiral.info/imapsync/"
  url "https://imapsync.lamiral.info/dist2/imapsync-1.882.tgz"
  # Note the mirror will return 404 until the version becomes outdated.
  sha256 "e4d8556b0273d1f0edaeb8d0d56533f0bfa7154c109bd10c586cd50bfc8a7ed5"
  head "https://github.com/imapsync/imapsync.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af1e8f2905d31aaa1123c9be542ba94bc6e0141f96a8b264e7dea80c6dbd3d5c" => :mojave
    sha256 "b68c9774710e5d3c47b88dcb6df93789c868c2dc29bf2380b4f316d560871498" => :high_sierra
    sha256 "ca33697e25f4b8a971b501ff4e68c52285706dfd450a81525648ebb22058a577" => :sierra
    sha256 "c0518b4b531892a033cb142f6f1c39919953ba61143b5d8bb9661ea7ae8bb294" => :el_capitan
  end

  resource "Unicode::String" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/GAAS/Unicode-String-2.10.tar.gz"
    sha256 "894a110ece479546af8afec0972eec7320c86c4dea4e6b354dff3c7526ba9b68"
  end

  resource "File::Copy::Recursive" do
    url "https://cpan.metacpan.org/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.44.tar.gz"
    sha256 "ae19a0b58dc1b3cded9ba9cfb109288d8973d474c0b4bfd28b27cf60e8ca6ee4"
  end

  resource "Authen::NTLM" do
    url "https://cpan.metacpan.org/authors/id/N/NB/NBEBOUT/NTLM-1.09.tar.gz"
    sha256 "c823e30cda76bc15636e584302c960e2b5eeef9517c2448f7454498893151f85"
  end

  resource "Mail::IMAPClient" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.39.tar.gz"
    sha256 "b541fdb47d5bca93048bcee69f42ad2cc96af635557ba6a9db1d8f049a434ea3"
  end

  resource "IO::Tee" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/IO-Tee-0.65.tar.gz"
    sha256 "c63dcd109b268962f867407da2654282e3c85113dc7e9655fe8a62331d490c12"
  end

  resource "Data::Uniqid" do
    url "https://cpan.metacpan.org/authors/id/M/MW/MWX/Data-Uniqid-0.12.tar.gz"
    sha256 "b6919ba49b9fe98bfdf3e8accae7b9b7f78dc9e71ebbd0b7fef7a45d99324ccb"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-2.97001.tar.gz"
    sha256 "e277d9385633574923f48c297e1b8acad3170c69fa590e31fa466040fc6f8f5a"
  end

  resource "Test::MockObject" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHROMATIC/Test-MockObject-1.20161202.tar.gz"
    sha256 "14b225fff3645338697976dbbe2c39e44c1c93536855b78b3bbc6e9bfe94a0a2"
  end

  resource "JSON::WebToken" do
    url "https://cpan.metacpan.org/authors/id/X/XA/XAICRON/JSON-WebToken-0.10.tar.gz"
    sha256 "77c182a98528f1714d82afc548d5b3b4dc93e67069128bb9b9413f24cf07248b"
  end

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz"
    sha256 "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c"
  end

  resource "Readonly" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SANKO/Readonly-2.05.tar.gz"
    sha256 "4b23542491af010d44a5c7c861244738acc74ababae6b8838d354dfb19462b5e"
  end

  resource "Sys::MemInfo" do
    url "https://cpan.metacpan.org/authors/id/S/SC/SCRESTO/Sys-MemInfo-0.99.tar.gz"
    sha256 "0786319d3a3a8bae5d727939244bf17e140b714f52734d5e9f627203e4cf3e3b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    build_pl = ["JSON::WebToken", "Module::Build::Tiny", "Readonly"]

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

    system "perl", "-c", "imapsync"
    system "pod2man", "imapsync", "imapsync.1"
    bin.install "imapsync"
    man1.install "imapsync.1"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    output = shell_output("#{bin}/imapsync --dry", 255)
    assert_match version.to_s, output
    resources.each do |r|
      next if ["Module::Build::Tiny", "Readonly", "Sys::MemInfo"].include? r.name
      assert_match /#{r.name}\s+#{r.version}/, output
    end
  end
end
