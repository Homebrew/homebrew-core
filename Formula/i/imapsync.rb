class Imapsync < Formula
  desc "Migrate or backup IMAP mail accounts"
  homepage "https://imapsync.lamiral.info/"
  url "https://imapsync.lamiral.info/dist2/imapsync-2.314.tgz"
  # NOTE: The mirror will return 404 until the version becomes outdated.
  sha256 "34e1715c6584889ff3bd9c0acc2fab254446282beda90c8e5a71a83b3a59dbca"
  license "NLPL"
  head "https://github.com/imapsync/imapsync.git", branch: "master"

  livecheck do
    url "https://imapsync.lamiral.info/dist2/"
    regex(/href=.*?imapsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f407b5ac18dc912864150ceade929689b707569a6bf21624a32f453aef3f0a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c4a8219d8f90921713ba21e235b13ee1894984e7aff4b5c5779f33083afb5f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb8f896a90ca433339f0bc4440375cd7fa5f44fa199ca3d938a764ce1e5e3148"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad64d2ca74795ebd8f022d65d0d7ac52dd580cfc98cbf4600deb60fdd9e55f63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ad7c2de7c9ad4fb055227eeb7887c6aa1d523ed75210c07da245c7f24e3e216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b788e7bf24d14b8f1ad33bc2772ac947406ebcaaeb25b55908f7e26e56f4a66"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"

    resource "Digest::HMAC_SHA1" do
      url "https://cpan.metacpan.org/authors/id/A/AR/ARODLAND/Digest-HMAC-1.05.tar.gz"
      sha256 "215cb59cba610745cfb2d4b3f8ef756d590e57e3ad7986a992e87c4969fcdc7a"
    end

    resource "IO::Socket::INET6" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/IO-Socket-INET6-2.73.tar.gz"
      sha256 "b6da746853253d5b4ac43191b4f69a4719595ee13a7ca676a8054cf36e6d16bb"
    end

    resource "Socket6" do
      url "https://cpan.metacpan.org/authors/id/U/UM/UMEMOTO/Socket6-0.29.tar.gz"
      sha256 "468915fa3a04dcf6574fc957eff495915e24569434970c91ee8e4e1459fc9114"
    end

    resource "IO::Socket::SSL" do
      url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.095.tar.gz"
      sha256 "7e764392b1b8bd44e654183c082b75be47800e98d7cd325f0e1b76c7d9a6b768"
    end

    resource "Net::SSLeay" do
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.94.tar.gz"
      sha256 "9d7be8a56d1bedda05c425306cc504ba134307e0c09bda4a788c98744ebcd95d"
    end

    resource "Term::ReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end

    resource "Regexp::Common" do
      url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2024080801.tar.gz"
      sha256 "0677afaec8e1300cefe246b4d809e75cdf55e2cc0f77c486d13073b69ab4fbdd"
    end

    resource "ExtUtils::Config" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.010.tar.gz"
      sha256 "82e7e4e90cbe380e152f5de6e3e403746982d502dd30197a123652e46610c66d"
    end

    resource "ExtUtils::Helpers" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.028.tar.gz"
      sha256 "c8574875cce073e7dc5345a7b06d502e52044d68894f9160203fcaab379514fe"
    end

    resource "ExtUtils::InstallPaths" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.014.tar.gz"
      sha256 "ae65d20cc3c7e14b3cd790915c84510f82dfb37a4c9b88aa74b2e843af417d01"
    end
  end

  resource "Module::Build" do
    on_system :linux, macos: :catalina_or_older do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
      sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
    end
  end

  resource "Encode::IMAPUTF7" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Encode-IMAPUTF7-1.07.tar.gz"
    sha256 "52352b8ac0843b932f2a3c4abf817d3ce5a1b71274e1ad9d4e4eb094eb0f1d1c"
  end

  resource "Unicode::String" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/GAAS/Unicode-String-2.10.tar.gz"
    sha256 "894a110ece479546af8afec0972eec7320c86c4dea4e6b354dff3c7526ba9b68"
  end

  resource "File::Copy::Recursive" do
    url "https://cpan.metacpan.org/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.45.tar.gz"
    sha256 "d3971cf78a8345e38042b208bb7b39cb695080386af629f4a04ffd6549df1157"
  end

  resource "Authen::NTLM" do
    url "https://cpan.metacpan.org/authors/id/N/NB/NBEBOUT/NTLM-1.09.tar.gz"
    sha256 "c823e30cda76bc15636e584302c960e2b5eeef9517c2448f7454498893151f85"
  end

  resource "Mail::IMAPClient" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.43.tar.gz"
    sha256 "093c97fac15b47a8fe4d2936ef2df377abf77cc8ab74092d2128bb945d1fb46f"
  end

  resource "IO::Tee" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/IO-Tee-0.66.tar.gz"
    sha256 "2d9ce7206516f9c30863a367aa1c2b9b35702e369b0abaa15f99fb2cc08552e0"
  end

  resource "Data::Uniqid" do
    url "https://cpan.metacpan.org/authors/id/M/MW/MWX/Data-Uniqid-0.12.tar.gz"
    sha256 "b6919ba49b9fe98bfdf3e8accae7b9b7f78dc9e71ebbd0b7fef7a45d99324ccb"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
  end

  resource "Test::MockObject" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHROMATIC/Test-MockObject-1.20200122.tar.gz"
    sha256 "2b7f80da87f5a6fe0360d9ee521051053017442c3a26e85db68dfac9f8307623"
  end

  resource "JSON::WebToken" do
    url "https://cpan.metacpan.org/authors/id/X/XA/XAICRON/JSON-WebToken-0.10.tar.gz"
    sha256 "77c182a98528f1714d82afc548d5b3b4dc93e67069128bb9b9413f24cf07248b"
  end

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.052.tar.gz"
    sha256 "bd10452c9f24d4b4fe594126e3ad231bab6cebf16acda40a4e8dc784907eb87f"
  end

  resource "Readonly" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SANKO/Readonly-2.05.tar.gz"
    sha256 "4b23542491af010d44a5c7c861244738acc74ababae6b8838d354dfb19462b5e"
  end

  resource "Sys::MemInfo" do
    url "https://cpan.metacpan.org/authors/id/S/SC/SCRESTO/Sys-MemInfo-0.99.tar.gz"
    sha256 "0786319d3a3a8bae5d727939244bf17e140b714f52734d5e9f627203e4cf3e3b"
  end

  resource "File::Tail" do
    url "https://cpan.metacpan.org/authors/id/M/MG/MGRABNAR/File-Tail-1.3.tar.gz"
    sha256 "26d09f81836e43eae40028d5283fe5620fe6fe6278bf3eb8eb600c48ec34afc7"
  end

  resource "IO::Socket::IP" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/IO-Socket-IP-0.43.tar.gz"
    sha256 "ebf6217f48f537ae9a78126f0ecb4baa3d4820e3e26153ce250f3bffd05f6d0b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    build_pl = ["Module::Build", "JSON::WebToken", "Module::Build::Tiny", "Readonly", "IO::Socket::IP"]

    resources.each do |r|
      r.stage do
        next if build_pl.include? r.name

        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    # Big Sur has a sufficiently new Module::Build
    build_pl.shift if OS.mac? && MacOS.version >= :big_sur

    build_pl.each do |name|
      resource(name).stage do
        system "perl", "Build.PL", "--install_base", libexec
        system "./Build"
        system "./Build", "install"
      end
    end

    system "perl", "-c", "imapsync"
    system "#{Formula["pod2man"].opt_bin}/pod2man", "imapsync", "imapsync.1"
    bin.install "imapsync"
    man1.install "imapsync.1"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/imapsync --dry")
    shell_output("#{bin}/imapsync --dry \
       --host1 test1.lamiral.info --user1 test1 --password1 secret1 \
       --host2 test2.lamiral.info --user2 test2 --password2 secret2")
  end
end
