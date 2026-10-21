class GetIplayer < Formula
  desc "Utility for downloading TV and radio programmes from BBC iPlayer"
  homepage "https://github.com/get-iplayer/get_iplayer"
  url "https://github.com/get-iplayer/get_iplayer/archive/refs/tags/v3.36.tar.gz"
  sha256 "9a70383143b6e3f43ee079f551b7f5719037ada86eb48d9defc66e00e619d996"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/get-iplayer/get_iplayer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f93f33e272adb05b019697a0f1327ba0fb21ed28102647f63a95bd4d8826250b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f93f33e272adb05b019697a0f1327ba0fb21ed28102647f63a95bd4d8826250b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f93f33e272adb05b019697a0f1327ba0fb21ed28102647f63a95bd4d8826250b"
    sha256 cellar: :any,                 arm64_linux:       "872e946258c91ea8b7462d54f858fbbd3c7a761ede544a57ccba9d0318ec0d44"
    sha256 cellar: :any,                 x86_64_linux:      "6d9a58ad052bb813fe5fa591c994ee4ae4a86f23921dff10fa7f8de8c7ee1ae7"
  end

  depends_on "atomicparsley"
  depends_on "ffmpeg"

  uses_from_macos "libxml2"
  uses_from_macos "perl"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@4"

    # LWP, LWP::Protocol::https, XML::LibXML and CGI
    resource "Capture::Tiny" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.50.tar.gz"
      sha256 "ca6e8d7ce7471c2be54e1009f64c367d7ee233a2894cacf52ebe6f53b04e81e5"
    end

    resource "File::Which" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
      sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
    end

    resource "FFI::CheckLib" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/FFI-CheckLib-0.31.tar.gz"
      sha256 "04d885fc377d44896e5ea1c4ec310f979bb04f2f18658a7e7a4d509f7e80bb80"
    end

    resource "File::chdir" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1011.tar.gz"
      sha256 "31ebf912df48d5d681def74b9880d78b1f3aca4351a0ed1fe3570b8e03af6c79"
    end

    resource "Path::Tiny" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.150.tar.gz"
      sha256 "ff20713d1a14d257af9c78209001f40dc177e4b9d1496115cbd8726d577946c7"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.40.tar.gz"
      sha256 "ef5d2ef099a1a24a6e83ffe543de73337805d3d39c00b84fa205d725ad1a1b63"
    end

    resource "Alien::Base::Wrapper" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.88.tar.gz"
      sha256 "c14346bace2b50cae62f1ee70a907f4c7383fabf90b034272ee52a5b1345fbba"
    end

    resource "Alien::Build::Plugin::Download::GitLab" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-Plugin-Download-GitLab-0.01.tar.gz"
      sha256 "c1f089c8ea152a789909d48a83dbfcf2626f773daf30431c8622582b26aba902"
    end

    resource "Alien::Libxml2" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.20.tar.gz"
      sha256 "56aae7b339bbeb02f77c5801f57a821be5791b51f43bf7f9062bb3bfa444c328"
    end

    resource "CGI" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEEJO/CGI-4.72.tar.gz"
      sha256 "babc1ca72db188083a1c3812debe88c4473b943b1f7c662281cd57c580a8bdd9"
    end

    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.51.tar.gz"
      sha256 "f17f66fec97dacca67ac9585701d2d079cfc80539fe6e8160c201c4e55f67507"
    end

    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    resource "File::Listing" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
      sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.08.tar.gz"
      sha256 "b57d80ca6d821c6949ca48b27467d45aba7a9c77346562306facca781a003e44"
    end

    resource "HTML::Entities" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.86.tar.gz"
      sha256 "5305e1d5faa70ee0aa282d85a5c9aa93911e8c7afa590ad1ced5703a544e20f6"
    end

    resource "HTML::Tagset" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
      sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
    end

    resource "HTTP::Cookies" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.12.tar.gz"
      sha256 "4e460c4bae76285bfc726f641349402fc9038fcd9ca0f33346bec036d73876b8"
    end

    resource "HTTP::Message" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-7.04.tar.gz"
      sha256 "699f3350dbb7bd8fdc9f3b013b0c91b7c059783708443e39bc395fa33352f006"
    end

    resource "HTTP::Negotiate" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
      sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
    end

    resource "IO::HTML" do
      url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
      sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
    end

    resource "IO::Socket::SSL" do
      url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.099.tar.gz"
      sha256 "a0be800ff4852b1567ee5500e772417ad7a360abff80c01b5b875c15d44be832"
    end

    resource "LWP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.83.tar.gz"
      sha256 "e75f0fa9d3c6f0daf5a5a72fa9f8b1c9c0d23e3a84a8522ccb4f835232b95505"
    end

    resource "LWP::MediaTypes" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.05.tar.gz"
      sha256 "abb2dcfbf069317fe65b098e3b2ad58c5eb33e9a839b9190cce6d371f8966cc1"
    end

    resource "LWP::Protocol::https" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.17.tar.gz"
      sha256 "361c7c1eee8cf66812958f975f26ef2e2272a0c6221d2043477cb9c22b8d1c23"
    end

    resource "MIME::Base32" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz"
      sha256 "ab21fa99130e33a0aff6cdb596f647e5e565d207d634ba2ef06bdbef50424e99"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.24.tar.gz"
      sha256 "290ed9a97b05c7935b048e6d2a356035871fca98ad72c01c5961726adf85c83c"
    end

    resource "Net::SSLeay" do
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.96.tar.gz"
      sha256 "ab213691685fb2a576c669cbc8d9266f8165a31563ad15b7c4030b94adfc0753"

      # Backport support for OpenSSL 4.0
      patch do
        url "https://github.com/radiator-software/p5-net-ssleay/commit/a55abab4a33b040fbd56cc18fde6c257af2928e2.patch?full_index=1"
        sha256 "dd0fab47cfb05393ba1124f0b3fcbdf43cb346212ca145beed5aa8af9dfbd12d"
        type :backport
        resolves "https://github.com/radiator-software/p5-net-ssleay/pull/553"
      end
    end

    resource "Time::Zone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.35.tar.gz"
      sha256 "baddd0306ae2e86e9ec28d3de5439e514643e80b3735e43bd0fbb426d73304de"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.32.tar.gz"
      sha256 "ef2d6cab0bad18e3ab1c4e6125cc5f695c7e459899f512451c8fa3ef83fa7fc0"
    end

    resource "WWW::RobotRules" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/WWW-RobotRules-6.03.tar.gz"
      sha256 "8522b532935a11bfa688c2e113bac66729df4851be50c2c26d4b06f45fade472"
    end

    resource "XML::LibXML" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-LibXML-2.0213.tar.gz"
      sha256 "2af21c5d61ac34ea26a5fabf15ba5a5841e648f7189db3e33b6f28b5489802ab"
    end

    resource "XML::NamespaceSupport" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz"
      sha256 "47e995859f8dd0413aa3f22d350c4a62da652e854267aa0586ae544ae2bae5ef"
    end

    resource "XML::SAX::Base" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
      sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
    end

    resource "XML::SAX" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-1.02.tar.gz"
      sha256 "4506c387043aa6a77b455f00f57409f3720aa7e553495ab2535263b4ed1ea12a"
    end
  end

  resource "Mojolicious" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SRI/Mojolicious-9.51.tar.gz"
    sha256 "56ddea0c74f65ed17d3d5eff2b79ff2f151a0ccb2b6aa63e3fe94bdd52e1de09"
  end

  deny_network_access!

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["NO_NETWORK_TESTING"] = "1"
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV["OPENSSL_PREFIX"] = formula_opt_prefix("openssl@4") if OS.linux?

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    inreplace ["get_iplayer", "get_iplayer.cgi"] do |s|
      s.gsub!(/^(my \$version_text);/i, "\\1 = \"#{pkg_version}-homebrew\";")
    end

    bin.install "get_iplayer", "get_iplayer.cgi"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    man1.install "get_iplayer.1"
  end

  test do
    output = shell_output("\"#{bin}/get_iplayer\" -f --refresh-include=\"BBC None\" -q dontshowanymatches 2>&1")
    assert_match "get_iplayer #{pkg_version}-homebrew", output, "Unexpected version"
    assert_match "INFO: 0 matching programmes", output, "Unexpected output"
    assert_match "INFO: Indexing tv programme schedules", output,
                         "Mojolicious not found"
  end
end
