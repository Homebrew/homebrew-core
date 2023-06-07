class Abricate < Formula
  desc "Find antimicrobial resistance and virulence genes in contigs"
  homepage "https://github.com/tseemann/abricate"
  url "https://github.com/tseemann/abricate/archive/v1.0.1.tar.gz"
  sha256 "5edc6b45a0ff73dcb4f1489a64cb3385d065a6f29185406197379522226a5d20"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/tseemann/abricate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b984059bb2be49d00ce2315ddf88b8a3b8db14f05b61fb25acf2a924b4a473a2"
    sha256 cellar: :any_skip_relocation, monterey:      "d44ec888720ff6c8482b715719659ad157660a470bc4678de2f9a9eb5d2c97e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "09ccff359b51bd0514ad4bc6e18af2514834157f34fe0dc24d1d787ee88e4aad"
    sha256 cellar: :any_skip_relocation, catalina:      "a59617da9f47e29ce7b10d1f004388cdcae345b1e1acb35b87b02b22776239f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "796c80bfb1a72148b9990823f1232434a0a2c01b1c652a6177d019d3ea273da4"
  end

  depends_on "bioperl"
  depends_on "blast"
  depends_on "openssl@1.1"
  depends_on "perl"

  uses_from_macos "unzip"

  resource "any2fasta" do
    url "https://raw.githubusercontent.com/tseemann/any2fasta/v0.4.2/any2fasta"
    sha256 "ed20e895c7a94d246163267d56fce99ab0de48784ddda2b3bf1246aa296bf249"
  end

  # Perl dependencies originally installed via cpanminus.
  # For `JSON Path::Tiny List::MoreUtils LWP::Simple` and dependencies.
  resource "JSON" do
    url "http://www.cpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.09.tar.gz"
    sha256 "6780a51f438c0932eec0534fc9cd2b1ad0d64817eda4add8ede5ec77d6d2c991"
  end
  resource "Path::Tiny" do
    url "http://www.cpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.124.tar.gz"
    sha256 "fa083144781e46817ec39d21962bbbb0533c201f3baf031d2999a785a2a013fd"
  end
  resource "List::MoreUtils::XS" do
    url "http://www.cpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz"
    sha256 "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242"
  end
  resource "Exporter::Tiny" do
    url "http://www.cpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.004003.tar.gz"
    sha256 "7c6852f18367af05f03912f007a1fac318471a870a457f0e502c11adcf9a457b"
  end
  resource "List::MoreUtils" do
    url "http://www.cpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz"
    sha256 "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527"
  end
  resource "URI" do
    url "http://www.cpan.org/authors/id/O/OA/OALDERS/URI-5.12.tar.gz"
    sha256 "66abe0eaddd76b74801ecd28ec1411605887550fc0a45ef6aa744fdad768d9b3"
  end
  resource "LWP::MediaTypes" do
    url "http://www.cpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
    sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
  end
  resource "Encode::Locale" do
    url "http://www.cpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
    sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
  end
  resource "Time::Zone" do
    url "http://www.cpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
    sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
  end
  resource "HTTP::Date" do
    url "http://www.cpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
    sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
  end
  resource "IO::HTML" do
    url "http://www.cpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
    sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
  end
  resource "HTTP::Request" do
    url "http://www.cpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.37.tar.gz"
    sha256 "0e59da0a85e248831327ebfba66796314cb69f1bfeeff7a9da44ad766d07d802"
  end
  resource "HTML::Tagset" do
    url "http://www.cpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz"
    sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
  end
  resource "HTML::HeadParser" do
    url "http://www.cpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.78.tar.gz"
    sha256 "22564002f206af94c1dd8535f02b0d9735125d9ebe89dd0ff9cd6c000e29c29d"
  end
  resource "Try::Tiny" do
    url "http://www.cpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
    sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
  end
  resource "HTTP::Cookies" do
    url "http://www.cpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.10.tar.gz"
    sha256 "e36f36633c5ce6b5e4b876ffcf74787cc5efe0736dd7f487bdd73c14f0bd7007"
  end
  resource "File::Listing" do
    url "http://www.cpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.15.tar.gz"
    sha256 "46c4fb9f9eb9635805e26b7ea55b54455e47302758a10ed2a0b92f392713770c"
  end
  resource "WWW::RobotRules" do
    url "http://www.cpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end
  resource "HTTP::Negotiate" do
    url "http://www.cpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end
  resource "Net::HTTP" do
    url "http://www.cpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.22.tar.gz"
    sha256 "62faf9a5b84235443fe18f780e69cecf057dea3de271d7d8a0ba72724458a1a2"
  end
  resource "LWP::Simple" do
    url "http://www.cpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.67.tar.gz"
    sha256 "96eec40a3fd0aa1bd834117be5eb21c438f73094d861a1a7e5774f0b1226b723"
  end

  def install
    resource("any2fasta").stage do
      bin.install "any2fasta"
    end

    ENV.prepend_path "PERL5LIB", Formula["bioperl"].opt_libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"perl5/lib/perl5"
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@1.1"].opt_prefix # for Net::SSLeay

    resources.each do |r|
      next if r.name == "any2fasta"

      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}/perl5"
        system "make", "install"
      end
    end

    libexec.install Dir["*"]
    %w[abricate abricate-get_db].each do |name|
      (bin/name).write_env_script("#{libexec}/bin/#{name}", PERL5LIB: ENV["PERL5LIB"])
    end
  end

  def post_install
    system "#{bin}/abricate", "--setupdb"
  end

  test do
    assert_match "resfinder", shell_output("#{bin}/abricate --list 2>&1")
    assert_match "--db", shell_output("#{bin}/abricate --help")
    assert_match "OK", shell_output("#{bin}/abricate --check 2>&1")
    assert_match "download", shell_output("#{bin}/abricate-get_db --help 2>&1")
    cp_r libexec/"test", testpath
    assert_match "penicillinase repressor BlaI", shell_output("#{bin}/abricate --fofn test/fofn.txt")
  end
end
