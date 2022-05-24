class GetFlashVideos < Formula
  desc "Download or play videos from various Flash-based websites"
  homepage "https://github.com/monsieurvideo/get-flash-videos"
  url "https://github.com/monsieurvideo/get-flash-videos/archive/1.25.99.03.tar.gz"
  sha256 "37267b41c7b0c240d99ed1f5e7ba04d00f98a8daff82ac9edd2b12c3bca83d73"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "168600d7a501abf32e1243c34491a501913c16034de8021d73128f2366fc717c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79a6359023b8e477bc3a033747b817c57a476cf19938a1ae484ce2a52f2ce4ef"
    sha256 cellar: :any_skip_relocation, monterey:       "e7e7d4e346def5ba7fa8f641f7c3803125e604370302f6f5667e667da2b364c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2778b4877b9a5f717f247e73ce571db7f3215ca6a31e77dfaaebc4d7b0664bd7"
    sha256 cellar: :any_skip_relocation, catalina:       "aac5558ccf7b7198eb48b71d7cdb9d07b93f4174926182a6e540678b0c4f9648"
    sha256 cellar: :any_skip_relocation, mojave:         "f67cf7971842dbfaa8f8ecb24ba6692bd506688c4ff6b0e51cc05dd3d13f6d11"
  end

  depends_on "rtmpdump"

  uses_from_macos "perl"

  on_linux do
    resource "Module::Find" do
      url "https://cpan.metacpan.org/authors/id/C/CR/CRENZ/Module-Find-0.13.tar.gz"
      sha256 "4a47862072ca4962fa69796907476049dc60176003e946cf4b68a6b669f18568"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.28.tar.gz"
      sha256 "f1d166be8aa19942c4504c9111dade7aacb981bc5b3a2a5c5f6019646db8c146"
    end

    resource "XML::Simple" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-Simple-2.24.tar.gz"
      sha256 "9a14819fd17c75fbb90adcec0446ceab356cab0ccaff870f2e1659205dc2424f"
    end
  end

  resource "Crypt::Blowfish_PP" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTBM/Crypt-Blowfish_PP-1.12.tar.gz"
    sha256 "714f1a3e94f658029d108ca15ed20f0842e73559ae5fc1faee86d4f2195fcf8c"
  end

  resource "LWP::Protocol" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.33.tar.gz"
    sha256 "97417386f11f007ae129fe155b82fd8969473ce396a971a664c8ae6850c69b99"
  end

  resource "Tie::IxHash" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz"
    sha256 "fabb0b8c97e67c9b34b6cc18ed66f6c5e01c55b257dcf007555e0b027d4caf56"
  end

  resource "WWW::Mechanize" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/WWW-Mechanize-1.88.tar.gz"
    sha256 "36d97e778ab911ab5a762d551541686cbf3463c571f474322f7b5da77f50a879"
  end

  resource "Term::ProgressBar" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MANWAR/Term-ProgressBar-2.21.tar.gz"
    sha256 "66994f1a6ca94d8d92e3efac406142fb0d05033360c0acce2599862db9c30e44"
  end

  resource "Class::MethodMaker" do
    url "https://cpan.metacpan.org/authors/id/S/SC/SCHWIGON/class-methodmaker/Class-MethodMaker-2.24.tar.gz"
    sha256 "5eef58ccb27ebd01bcde5b14bcc553b5347a0699e5c3e921c7780c3526890328"
  end

  resource "Crypt::Rijndael" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Crypt-Rijndael-1.13.tar.gz"
    sha256 "cd7209a6dfe0a3dc8caffe1aa2233b0e6effec7572d76a7a93feefffe636214e"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV.prepend_create_path "PERL5LIB", lib/"perl5"
    system "make"
    (lib/"perl5").install "blib/lib/FlashVideo"

    bin.install "bin/get_flash_videos"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    chmod 0755, libexec/"bin/get_flash_videos"

    man1.install "blib/man1/get_flash_videos.1"
  end

  test do
    assert_match "Filename: BBC_-__Do_whatever_it_takes_to_get_him_to_talk.flv",
      shell_output("#{bin}/get_flash_videos --info http://news.bbc.co.uk/2/hi/programmes/hardtalk/9560793.stm")
  end
end
