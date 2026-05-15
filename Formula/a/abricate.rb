class Abricate < Formula
  desc "Find antimicrobial resistance and virulence genes in contigs"
  homepage "https://github.com/tseemann/abricate"
  url "https://github.com/tseemann/abricate/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "cbafe0efbdb7a0ac3d3bcd3cb2ca4a0152474d20b68c5f98da5a4c7cc25676eb"
  license "GPL-2.0-only"
  head "https://github.com/tseemann/abricate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdeeab2a8f7508fca1997787b6df48f8c255662ab35e9b48f46b9725eb8df4b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdeeab2a8f7508fca1997787b6df48f8c255662ab35e9b48f46b9725eb8df4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdeeab2a8f7508fca1997787b6df48f8c255662ab35e9b48f46b9725eb8df4b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdeeab2a8f7508fca1997787b6df48f8c255662ab35e9b48f46b9725eb8df4b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69a7a2317e99329bf6e2fa29e9db1bfb127a9d941ef92eb51d8c57fd02621252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22bc97bf2b32603dcb53a3f5832c86425eb60bee776b7557623fb91091c503de"
  end

  depends_on "any2fasta"
  depends_on "bioperl"
  depends_on "blast"

  uses_from_macos "perl"
  uses_from_macos "unzip"

  # Perl dependencies originally installed via cpanminus.
  # For `JSON Path::Tiny List::MoreUtils LWP::Simple` and dependencies.
  # These are already installed in macOS perl.
  on_linux do
    resource "JSON" do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
      sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
    end

    resource "Path::Tiny" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.150.tar.gz"
      sha256 "ff20713d1a14d257af9c78209001f40dc177e4b9d1496115cbd8726d577946c7"
    end

    resource "List::MoreUtils::XS" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz"
      sha256 "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242"
    end

    resource "Exporter::Tiny" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.006002.tar.gz"
      sha256 "6f295e2cbffb1dbc15bdb9dadc341671c1e0cd2bdf2d312b17526273c322638d"
    end

    resource "List::MoreUtils" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz"
      sha256 "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.34.tar.gz"
      sha256 "de64c779a212ff1821896c5ca2bb69e74767d2674cee411e777deea7a22604a8"
    end

    resource "LWP::MediaTypes" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
      sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
    end

    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    resource "Time::Zone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
      sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
      sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
    end

    resource "IO::HTML" do
      url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
      sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
    end

    resource "HTTP::Request" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-7.01.tar.gz"
      sha256 "82b79ce680251045c244ee059626fecbf98270bed1467f0175ff5ea91071437e"
    end

    resource "HTML::Tagset" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
      sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
    end

    resource "HTML::HeadParser" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.83.tar.gz"
      sha256 "7278ce9791256132b26a71a5719451844704bb9674b58302c3486df43584f8c0"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.32.tar.gz"
      sha256 "ef2d6cab0bad18e3ab1c4e6125cc5f695c7e459899f512451c8fa3ef83fa7fc0"
    end

    resource "HTTP::Cookies" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.11.tar.gz"
      sha256 "8c9a541a4a39f6c0c7e3d0b700b05dfdb830bd490a1b1942a7dedd1b50d9a8c8"
    end

    resource "File::Listing" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
      sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
    end

    resource "WWW::RobotRules" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
      sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
    end

    resource "HTTP::Negotiate" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
      sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.24.tar.gz"
      sha256 "290ed9a97b05c7935b048e6d2a356035871fca98ad72c01c5961726adf85c83c"
    end

    resource "LWP::Simple" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.81.tar.gz"
      sha256 "ab30552f194e8b5ae3ac0885132fd1d4ea04c4c7fe6555765b98f01af70c1736"
    end

    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.47.tar.gz"
      sha256 "4c2c0cb9a483efbf970cb1a75b2ca75b0e18cb84bcb5c09624f86e26b09c211d"
    end
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["bioperl"].opt_libexec/"lib/perl5"

    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"perl5/lib/perl5"
      ENV["PERL_MM_USE_DEFAULT"] = "1"

      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}/perl5"
          system "make", "install"
        end
      end
    end

    prefix.install "bin"
    libexec.install Dir["*"]
    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]
  end

  def post_install
    system bin/"abricate", "--setupdb"
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
