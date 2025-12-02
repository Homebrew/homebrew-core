class Abricate < Formula
  desc "Find antimicrobial resistance and virulence genes in contigs"
  homepage "https://github.com/tseemann/abricate"
  url "https://github.com/tseemann/abricate/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "5edc6b45a0ff73dcb4f1489a64cb3385d065a6f29185406197379522226a5d20"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/tseemann/abricate.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcb7a6a43e558cea2253ef0d00cdb5344d7569844f3d9bab441c7095ac45beba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e7f6393112a6a35dce42b72269577f9a625cb161185fc24075afc326e057ad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e1dff52eb0bf1df021f9fa7cfe0e1a09df089e6bfc4af6c87e07a0f52db655"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1019399ae72e1e4b793e287b92c2b000b6680f44c60faa2aa63e61683fae70c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f72cb3d2b9f6d42fe8ff2ff6c72d9dab66d5e7a5f867ae384ae06f2477c8e53c"
    sha256 cellar: :any_skip_relocation, ventura:       "e64a514eafd58745186e9302e4a5fa0d9da4eb9e686ff15ec3fa53c29b9b3a3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6862ba41484e2752fbfa93c339fd12a691f164f5342a7864b8af2e786cbbe23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ccff5939400556b14677e73e48b33f8794781a62ed6df468bef9d240ecaffb4"
  end

  depends_on "bioperl"
  depends_on "blast"
  depends_on "perl"

  uses_from_macos "unzip"

  resource "any2fasta" do
    url "https://raw.githubusercontent.com/tseemann/any2fasta/v0.4.2/any2fasta"
    sha256 "ed20e895c7a94d246163267d56fce99ab0de48784ddda2b3bf1246aa296bf249"
  end

  # Perl dependencies originally installed via cpanminus.
  # For `JSON Path::Tiny List::MoreUtils LWP::Simple` and dependencies.
  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
  end

  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.144.tar.gz"
    sha256 "f6ea094ece845c952a02c2789332579354de8d410a707f9b7045bd241206487d"
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
    url "https://cpan.metacpan.org/authors/id/S/SI/SIMBABQUE/URI-5.19.tar.gz"
    sha256 "8fed5f819905c8a8e18f4447034322d042c3536b43c13ac1f09ba92e1a50a394"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
    sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
  end

  resource "IO::HTML" do
    url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
    sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
  end

  resource "HTTP::Request" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.44.tar.gz"
    sha256 "398b647bf45aa972f432ec0111f6617742ba32fc773c6612d21f64ab4eacbca1"
  end

  resource "HTML::Tagset" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz"
    sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
  end

  resource "HTML::HeadParser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.81.tar.gz"
    sha256 "c0910a5c8f92f8817edd06ccfd224ba1c2ebe8c10f551f032587a1fc83d62ff2"
  end

  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
    sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
  end

  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.10.tar.gz"
    sha256 "e36f36633c5ce6b5e4b876ffcf74787cc5efe0736dd7f487bdd73c14f0bd7007"
  end

  resource "File::Listing" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.15.tar.gz"
    sha256 "46c4fb9f9eb9635805e26b7ea55b54455e47302758a10ed2a0b92f392713770c"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.23.tar.gz"
    sha256 "0d65c09dd6c8589b2ae1118174d3c1a61703b6ecfc14a3442a8c74af65e0c94e"
  end

  resource "LWP::Simple" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.71.tar.gz"
    sha256 "9d852d92c1f087d838adcb4107c4ff69887e7e5bdb742f984639c4c18dddb6e7"
  end

  resource "Clone" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Clone-0.46.tar.gz"
    sha256 "aadeed5e4c8bd6bbdf68c0dd0066cb513e16ab9e5b4382dc4a0aafd55890697b"
  end

  def install
    resource("any2fasta").stage do
      bin.install "any2fasta"
    end

    ENV.prepend_path "PERL5LIB", Formula["bioperl"].opt_libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"perl5/lib/perl5"
    ENV["PERL_MM_USE_DEFAULT"] = "1"

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
