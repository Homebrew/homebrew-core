class Nikto < Formula
  desc "Web server scanner"
  homepage "https://cirt.net/nikto/"
  url "https://github.com/sullo/nikto/archive/refs/tags/2.6.1.tar.gz"
  sha256 "d1ca1acb05d81a5a6f374c0afdd76b33afa0089278631a20673c0210a71d992f"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c35f535d8885c015724569ceb2757ecb3b175f2d53f65e38aac053c73984c5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c35f535d8885c015724569ceb2757ecb3b175f2d53f65e38aac053c73984c5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c35f535d8885c015724569ceb2757ecb3b175f2d53f65e38aac053c73984c5b"
    sha256 cellar: :any,                 arm64_linux:       "9c1746d64ddadf53574d7822e4cddb553cffa71b8ff5989c36dfa1ee8af14a2a"
    sha256 cellar: :any,                 x86_64_linux:      "aa2f53f705ee66143958a1ae0d3aab24ff94b6734966975d2833797fe1c4dc28"
  end

  uses_from_macos "perl"

  on_linux do
    depends_on "zlib-ng-compat" => :build
    depends_on "openssl@4"

    # Modules loaded in program/nikto.pl and Net::SSLeay for program/plugins/LW2.pm
    resource "JSON" do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.11.tar.gz"
      sha256 "713bdbe724dbb915ed50265ffe47e079a511980cb2427aa19076788bb64c3182"
    end

    resource "List::Util" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.70.tar.gz"
      sha256 "e0cc03f9fe3565cdf4d6102654f87bba3bca2d8ff989da38307e857d0ae3c886"
    end

    resource "Socket" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Socket-2.041.tar.gz"
      sha256 "91f57ca9e5fcc5c7ce08e52e73841afafc56a688514d9d8b815cabe14a95b556"
    end

    resource "Time::Piece" do
      url "https://cpan.metacpan.org/authors/id/E/ES/ESAYM/Time-Piece-1.41.tar.gz"
      sha256 "606824c0a440c050232e25dc856517db884ce3f47f60b159219ffc666a17ba11"
    end

    resource "XML::Writer" do
      url "https://cpan.metacpan.org/authors/id/J/JO/JOSEPHW/XML-Writer-0.900.tar.gz"
      sha256 "73c8f5bd3ecf2b350f4adae6d6676d52e08ecc2d7df4a9f089fa68360d400d1f"
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
  end

  deny_network_access!

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV["PERL_MM_USE_DEFAULT"] = "1"
      ENV["OPENSSL_PREFIX"] = formula_opt_prefix("openssl@4")

      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "install"
        end
      end
    end

    cd "program" do
      inreplace "nikto.pl", "/etc/nikto.conf", "#{etc}/nikto.conf"

      inreplace "nikto.conf.default" do |s|
        s.gsub! "# EXECDIR=/opt/nikto", "EXECDIR=#{prefix}"
        s.gsub! "# PLUGINDIR=/opt/nikto/plugins",
                "PLUGINDIR=#{pkgshare}/plugins"
        s.gsub! "# DBDIR=/opt/nikto/databases",
                "DBDIR=#{var}/nikto/databases"
        s.gsub! "# TEMPLATEDIR=/opt/nikto/templates",
                "TEMPLATEDIR=#{pkgshare}/templates"
        s.gsub! "# DOCDIR=/opt/nikto/docs", "DOCDIR=#{doc}"
      end

      bin.install "nikto.pl" => "nikto"
      bin.install "utils/replay.pl"
      etc.install "nikto.conf.default" => "nikto.conf"
      pkgshare.install "plugins", "templates"
    end

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"]) if OS.linux?
    man1.install "documentation/nikto.1"
    doc.install Dir["documentation/*"]
    (var/"nikto/databases").mkpath
    cp_r Dir["program/databases/*"], var/"nikto/databases"
  end

  test do
    system bin/"nikto", "-H"
  end
end
