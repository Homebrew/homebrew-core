class Nikto < Formula
  desc "Web server scanner"
  homepage "https://cirt.net/nikto/"
  url "https://github.com/sullo/nikto/archive/refs/tags/2.6.0.tar.gz"
  sha256 "656554f9aeba8c462689582b59d141369dbcadac11141cd02752887f363430ec"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b25b9835dc21faf79f47275f8cb32fe189d8c93c8be6d19177831d8d095ff19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b25b9835dc21faf79f47275f8cb32fe189d8c93c8be6d19177831d8d095ff19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b25b9835dc21faf79f47275f8cb32fe189d8c93c8be6d19177831d8d095ff19"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b25b9835dc21faf79f47275f8cb32fe189d8c93c8be6d19177831d8d095ff19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81f0196a9ccf7113d62c1cb722dab0f4744a78eb88c605c36762921a49449af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecd1d17136bddbf40f16c1e19c92c8d5cadff0195d6710ecd1752a4883b71911"
  end

  uses_from_macos "perl"

  on_linux do
    depends_on "zlib-ng-compat" => :build
    depends_on "openssl@3"

    # Modules loaded in program/nikto.pl and Net::SSLeay for program/plugins/LW2.pm
    resource "JSON" do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
      sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
    end

    resource "List::Util" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.70.tar.gz"
      sha256 "e0cc03f9fe3565cdf4d6102654f87bba3bca2d8ff989da38307e857d0ae3c886"
    end

    resource "Socket" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Socket-2.040.tar.gz"
      sha256 "be0102fdcea8d43f1b02ef2ef94345ac4bbc7b6c66ece2ddd1a3593d8371ba1b"
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
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.94.tar.gz"
      sha256 "9d7be8a56d1bedda05c425306cc504ba134307e0c09bda4a788c98744ebcd95d"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV["PERL_MM_USE_DEFAULT"] = "1"

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
