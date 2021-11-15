class Imapsync < Formula
  desc "Migrate or backup IMAP mail accounts"
  homepage "https://imapsync.lamiral.info/"
  url "https://imapsync.lamiral.info/dist2/imapsync-2.140.tgz"
  # NOTE: The mirror will return 404 until the version becomes outdated.
  sha256 "faebfa61bffdb33c845fe53707be09761d96d717b75706b3ca927990654e7551"
  license "NLPL"
  head "https://github.com/imapsync/imapsync.git"

  livecheck do
    url "https://imapsync.lamiral.info/dist2/"
    regex(/href=.*?imapsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fedb049b72df96d628cf3de4c88261f8f3d37fbde861d8651e575991ed91722"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9ecf98890a33032f33265c911706a0e0cba29ad4cbc06f63bcabc31a7cbc4f6"
    sha256 cellar: :any_skip_relocation, monterey:       "a3474dd44ac609c0622cc4747ddfde122737962b7454b3b98470d4cf44dd05ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "292fd066f1f52cc748bf30395cc117b32c0e3ee62d4646e8d5aa4c9d620ba34e"
    sha256 cellar: :any_skip_relocation, catalina:       "ec79e8b2d77dea4bcf156ae5566f7c9ec3bed6157b62fc7543b93ca276e98b94"
    sha256 cellar: :any_skip_relocation, mojave:         "231ad4b8c618aea36959211b811e678ab9979afb483eb5f6508ffc3bd2a9f42f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e11b2c0dc44b342eda66d083d19ee75460af9c17026a43989a13e9f5c39957"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  on_linux do
    resource "Digest::HMAC_SHA1" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Digest-HMAC-1.03.tar.gz"
      sha256 "3bc72c6d3ff144d73aefb90e9a78d33612d58cf1cd1631ecfb8985ba96da4a59"
    end

    resource "IO::Socket::INET6" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/IO-Socket-INET6-2.72.tar.gz"
      sha256 "85e020fa179284125fc1d08e60a9022af3ec1271077fe14b133c1785cdbf1ebb"
    end

    resource "Socket6" do
      url "https://cpan.metacpan.org/authors/id/U/UM/UMEMOTO/Socket6-0.29.tar.gz"
      sha256 "468915fa3a04dcf6574fc957eff495915e24569434970c91ee8e4e1459fc9114"
    end

    resource "IO::Socket::SSL" do
      url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.066.tar.gz"
      sha256 "0d47064781a545304d5dcea5dfcee3acc2e95a32e1b4884d80505cde8ee6ebcd"
    end

    resource "Net::SSLeay" do
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.88.tar.gz"
      sha256 "2000da483c8471a0b61e06959e92a6fca7b9e40586d5c828de977d3d2081cfdd"
    end

    resource "Term::ReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end

    resource "Regexp::Common" do
      url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz"
      sha256 "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b"
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
  end

  resource "Encode::IMAPUTF7" do
    url "https://cpan.metacpan.org/authors/id/P/PM/PMAKHOLM/Encode-IMAPUTF7-1.05.tar.gz"
    sha256 "470305ddc37483cfe8d3c16d13770a28011f600bf557acb8c3e07739997c37e1"
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
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.03.tar.gz"
    sha256 "e41f8761a5e7b9b27af26fe5780d44550d7a6a66bf3078e337d676d07a699941"
  end

  resource "Test::MockObject" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHROMATIC/Test-MockObject-1.20200122.tar.gz"
    sha256 "2b7f80da87f5a6fe0360d9ee521051053017442c3a26e85db68dfac9f8307623"
  end

  if MacOS.version <= :catalina
    resource "Module::Build" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
      sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
    end
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

  resource "File::Tail" do
    url "https://cpan.metacpan.org/authors/id/M/MG/MGRABNAR/File-Tail-1.3.tar.gz"
    sha256 "26d09f81836e43eae40028d5283fe5620fe6fe6278bf3eb8eb600c48ec34afc7"
  end

  resource "IO::Socket::IP" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/IO-Socket-IP-0.41.tar.gz"
    sha256 "849a45a238f8392588b97722c850382c4e6d157cd08a822ddcb9073c73bf1446"
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
    build_pl.shift if MacOS.version >= :big_sur

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
