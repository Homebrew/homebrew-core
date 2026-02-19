class IconNamingUtils < Formula
  desc "Script to handle icon names in desktop icon themes"
  homepage "https://specifications.freedesktop.org/icon-naming/latest/"
  # Upstream seem to have enabled by default SSL/TLS across whole domain which
  # is problematic when the cert is for www rather than a wildcard or similar.
  # url "http://tango.freedesktop.org/releases/icon-naming-utils-0.8.90.tar.gz"
  url "https://deb.debian.org/debian/pool/main/i/icon-naming-utils/icon-naming-utils_0.8.90.orig.tar.gz"
  sha256 "044ab2199ed8c6a55ce36fd4fcd8b8021a5e21f5bab028c0a7cdcf52a5902e1c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/Version\s+v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0297c134b4aed0221b17224be3da86f54004e5d1ce7d12e4e9138b3335f65190"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3caca3e4bf1e45408fdd966f46f860a0fd9002f471a1fa258e9c3c66ab28b204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4875c2788c7c77a35e9af5ecda0d4ba48ec06668ed12acd5b95b77860a8e25ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d9b0891567661143495e9cb87f7811d66a7e980e26d403fdbd3485590f9bbf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d9b0891567661143495e9cb87f7811d66a7e980e26d403fdbd3485590f9bbf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b212434c2f761da7a71beffe6984969eda3f0b97853ad70a2c4b9318efb35f06"
    sha256 cellar: :any_skip_relocation, sonoma:         "4875c2788c7c77a35e9af5ecda0d4ba48ec06668ed12acd5b95b77860a8e25ca"
    sha256 cellar: :any_skip_relocation, ventura:        "0d9b0891567661143495e9cb87f7811d66a7e980e26d403fdbd3485590f9bbf7"
    sha256 cellar: :any_skip_relocation, monterey:       "0d9b0891567661143495e9cb87f7811d66a7e980e26d403fdbd3485590f9bbf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5f035a7553f25b130f64662cfea9fe25d8db0b7697f7f61e6ad52be8b8f24c5"
    sha256 cellar: :any_skip_relocation, catalina:       "6ed447fa2e57d32cc048b551ee67339d2be52d89f124e9dfddb3322cc0882883"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "089bbe93b74c60c6520d3269999e652427cf02a30e8825a7e70261af6ba7beaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2808ba5e1f6d084d4f424e084ead17462349b6b2c5d60e5162ecd633c7e3be2f"
  end

  depends_on "pkgconf" => :test

  uses_from_macos "perl"

  # XML::Simple dependency tree
  on_linux do
    depends_on "expat"

    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Clone-0.46.tar.gz"
      sha256 "aadeed5e4c8bd6bbdf68c0dd0066cb513e16ab9e5b4382dc4a0aafd55890697b"
    end
    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end
    resource "File::Listing" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
      sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
    end
    resource "HTML::HeadParser" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.83.tar.gz"
      sha256 "7278ce9791256132b26a71a5719451844704bb9674b58302c3486df43584f8c0"
    end
    resource "HTML::Tagset" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
      sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
    end
    resource "HTTP::Cookies" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.11.tar.gz"
      sha256 "8c9a541a4a39f6c0c7e3d0b700b05dfdb830bd490a1b1942a7dedd1b50d9a8c8"
    end
    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
      sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
    end
    resource "HTTP::Negotiate" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
      sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
    end
    resource "HTTP::Request" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.46.tar.gz"
      sha256 "e27443434150d2d1259bb1e5c964429f61559b0ae34b5713090481994936e2a5"
    end
    resource "IO::HTML" do
      url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
      sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
    end
    resource "LWP::MediaTypes" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
      sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
    end
    resource "LWP::UserAgent" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.77.tar.gz"
      sha256 "94a907d6b3ea8d966ef43deffd4fa31f5500142b4c00489bfd403860a5f060e4"
    end
    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.23.tar.gz"
      sha256 "0d65c09dd6c8589b2ae1118174d3c1a61703b6ecfc14a3442a8c74af65e0c94e"
    end
    resource "Time::Zone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
      sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
    end
    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
      sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
    end
    resource "URI::Escape" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.28.tar.gz"
      sha256 "e7985da359b15efd00917fa720292b711c396f2f9f9a7349e4e7dec74aa79765"
    end
    resource "WWW::RobotRules" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
      sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
    end
    resource "XML::NamespaceSupport" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz"
      sha256 "47e995859f8dd0413aa3f22d350c4a62da652e854267aa0586ae544ae2bae5ef"
    end
    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
      sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
    end
    resource "XML::SAX::Base" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
      sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
    end
    resource "XML::SAX" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-1.02.tar.gz"
      sha256 "4506c387043aa6a77b455f00f57409f3720aa7e553495ab2535263b4ed1ea12a"
    end
    resource "XML::SAX::Expat" do
      url "https://cpan.metacpan.org/authors/id/B/BJ/BJOERN/XML-SAX-Expat-0.51.tar.gz"
      sha256 "4c016213d0ce7db2c494e30086b59917b302db8c292dcd21f39deebd9780c83f"
    end
    resource "XML::Simple" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-Simple-2.25.tar.gz"
      sha256 "531fddaebea2416743eb5c4fdfab028f502123d9a220405a4100e68fc480dbf8"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make"
          if r.name == "XML::SAX::Expat"
            ENV.deparallelize { system "make", "install" }
          else
            system "make", "install"
          end
        end
      end
    end

    system "./configure", *std_configure_args
    system "make", "install"
    return unless OS.linux?

    libexec.install libexec/"icon-name-mapping" => "icon-name-mapping.pl"
    (libexec/"icon-name-mapping").write_env_script libexec/"icon-name-mapping.pl", PERL5LIB: ENV["PERL5LIB"]
    chmod "+x", libexec/"icon-name-mapping"
  end

  test do
    assert_equal libexec.to_s, shell_output("pkgconf --variable=program_path icon-naming-utils").chomp
    assert_match "Usage: icon-name-mapping", shell_output(libexec/"icon-name-mapping", 1)
  end
end
