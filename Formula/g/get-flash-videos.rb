class GetFlashVideos < Formula
  desc "Download or play videos from various Flash-based websites"
  homepage "https://github.com/monsieurvideo/get-flash-videos"
  url "https://github.com/monsieurvideo/get-flash-videos/archive/refs/tags/1.25.99.03.tar.gz"
  sha256 "37267b41c7b0c240d99ed1f5e7ba04d00f98a8daff82ac9edd2b12c3bca83d73"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1792f9d20bc21a285d0034483f1701f505c64c8a18cc9d75b0befa92c63ce662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e9585360bd6c0eedbb61d69471027f381bb98b90ec603d27e6054c070ff0bcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98e92953a3439040ea3927924daf3752535f29b6f090d7110f2f4f27cd07aec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5250458e7b842b0c47b8a0bf82d080088f1a15991b08b7c4b6b54a1af2694ecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b85cf6d7f8b77d4c8e49a4229bb1f65dbd7d5bdf46e278dd6222eb30e002ade1"
    sha256 cellar: :any_skip_relocation, ventura:       "4b38c8850c54efd5fcec94048eb5e35452647c1f85d2852f49d312ec4e120bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a17c87aed4e3b726a9a289de42ee4c725cd5b75a4c0c842a051396eaa8708e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc6d8ca49c01ff7cf2af1d97ff3e287ee30617b40bda0db332f794768cdbdca3"
  end

  # adobe flash player EOL 12/31/2020, https://www.adobe.com/products/flashplayer/end-of-life-alternative.html
  deprecate! date: "2025-03-21", because: :unmaintained

  depends_on "rtmpdump"

  uses_from_macos "openssl"
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

    resource "HTTP::Request" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.37.tar.gz"
      sha256 "0e59da0a85e248831327ebfba66796314cb69f1bfeeff7a9da44ad766d07d802"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.10.tar.gz"
      sha256 "16325d5e308c7b7ab623d1bf944e1354c5f2245afcfadb8eed1e2cae9a0bd0b5"
    end

    resource "LWP::UserAgent" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.67.tar.gz"
      sha256 "96eec40a3fd0aa1bd834117be5eb21c438f73094d861a1a7e5774f0b1226b723"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
      sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
    end

    resource "HTML::Form" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Form-6.07.tar.gz"
      sha256 "7daa8c7eaff4005501c3431c8bf478d58bbee7b836f863581aa14afe1b4b6227"
    end

    resource "HTML::TokeParser" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.78.tar.gz"
      sha256 "22564002f206af94c1dd8535f02b0d9735125d9ebe89dd0ff9cd6c000e29c29d"
    end

    resource "HTML::Tagset" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz"
      sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
    end

    resource "LWP::Protocol::https" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.10.tar.gz"
      sha256 "cecfc31fe2d4fc854cac47fce13d3a502e8fdfe60c5bc1c09535743185f2a86c"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.22.tar.gz"
      sha256 "62faf9a5b84235443fe18f780e69cecf057dea3de271d7d8a0ba72724458a1a2"
    end

    resource "IO::Socket::SSL" do
      url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.074.tar.gz"
      sha256 "36486b6be49da4d029819cf7069a7b41ed48af0c87e23be0f8e6aba23d08a832"
    end

    resource "Net::SSLeay" do
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.92.tar.gz"
      sha256 "47c2f2b300f2e7162d71d699f633dd6a35b0625a00cbda8c50ac01144a9396a9"
    end

    resource "HTTP::Cookies" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.10.tar.gz"
      sha256 "e36f36633c5ce6b5e4b876ffcf74787cc5efe0736dd7f487bdd73c14f0bd7007"
    end

    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz"
      sha256 "d331332491c51cccfb4cb94ffc44f9cd73378e618498d4a37df9e043661c515d"
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
    unless OS.mac?
      ENV["PERL_MM_USE_DEFAULT"] = "1"
      ENV["OPENSSL_PREFIX"] = Formula["openssl"].opt_prefix
    end

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
    # Replace cellar path to perl with opt path.
    if OS.linux?
      inreplace libexec/"bin/get_flash_videos",
                Formula["perl"].bin.realpath,
                Formula["perl"].opt_bin
    end

    man1.install "blib/man1/get_flash_videos.1"
  end

  test do
    expected = "Filename: BBC_-_Antarctic_ice_bridge_shatters.flv"
    assert_match expected, shell_output("#{bin}/get_flash_videos --info http://news.bbc.co.uk/1/hi/sci/tech/7983975.stm")
  end
end
