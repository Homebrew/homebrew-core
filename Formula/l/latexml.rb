class Latexml < Formula
  desc "LaTeX to XML/HTML/MathML Converter"
  homepage "https://dlmf.nist.gov/LaTeXML/"
  url "https://dlmf.nist.gov/LaTeXML/releases/LaTeXML-0.8.8.tar.gz"
  sha256 "7d2bbe2ce252baf86ba3f388cd0dec3aa4838f49d612b9ec7cc4ff88105badcc"
  license :public_domain
  revision 2
  head "https://github.com/brucemiller/LaTeXML.git", branch: "master"

  livecheck do
    url "https://dlmf.nist.gov/LaTeXML/get.html"
    regex(/href=.*?LaTeXML[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b04f2c5db4df15e69d6fc0c7a8f359e974fb71d663d28f910b7887e35077a248"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "398aefab0bbbe84fea807b76e47724cb4a9025f51e91892f752d04f185639ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "131fe20e76df2175ebff1bccc70e7e7279d25d5e51ff5f72732ba2933817b79f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7759474dfe2c67d6f64ed6b0439e3c93f20ad0df76146f71d5cac3ba80f87ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04fd37e658b0a2d036642aea41df66a046fcc59dc61e2c5a9f86a852a1cb75a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b8ad83d90d8f448c9d968c75f8a25dd9dd34bdac2b822f22ac1706615f523c0"
  end

  depends_on "pkgconf" => :build
  # macOS system perl hits an issue on Big Sur due to XML::LibXSLT
  # Ref: https://github.com/Homebrew/homebrew-core/pull/94387
  depends_on "perl"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  # Only the following perl resources are needed when using macOS system perl

  resource "Image::Size" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz"
    sha256 "53c9b1f86531cde060ee63709d1fda73cabc0cf2d581d29b22b014781b9f026b"
  end

  resource "Text::Unidecode" do
    url "https://cpan.metacpan.org/authors/id/S/SB/SBURKE/Text-Unidecode-1.30.tar.gz"
    sha256 "6c24f14ddc1d20e26161c207b73ca184eed2ef57f08b5fb2ee196e6e2e88b1c6"
  end

  # The remaining perl resources are needed when using Homebrew perl,
  # which we have switched to due to an issue in Big Sur's XML::LibXSLT:
  #   Can't load '.../LibXSLT.bundle' for module XML::LibXSLT:
  #   symbol '_exsltRegisterAll' not found, expected in flat namespace

  resource "Archive::Zip" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/Archive-Zip-1.68.tar.gz"
    sha256 "984e185d785baf6129c6e75f8eb44411745ac00bf6122fb1c8e822a3861ec650"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end

  resource "IO::String" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz"
    sha256 "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
  end

  # JSON::XS build dependency
  resource "Canary::Stability" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/Canary-Stability-2013.tar.gz"
    sha256 "a5c91c62cf95fcb868f60eab5c832908f6905221013fea2bce3ff57046d7b6ea"
  end

  # JSON::XS dependencies
  resource "common::sense" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/common-sense-3.75.tar.gz"
    sha256 "a86a1c4ca4f3006d7479064425a09fa5b6689e57261fcb994fe67d061cba0e7e"
  end
  resource "Types::Serialiser" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/Types-Serialiser-1.01.tar.gz"
    sha256 "f8c7173b0914d0e3d957282077b366f0c8c70256715eaef3298ff32b92388a80"
  end

  resource "JSON::XS" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/JSON-XS-4.03.tar.gz"
    sha256 "515536f45f2fa1a7e88c8824533758d0121d267ab9cb453a1b5887c8a56b9068"
  end

  resource "Parse::RecDescent" do
    url "https://cpan.metacpan.org/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz"
    sha256 "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37"
  end

  resource "Pod::Parser" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.67.tar.gz"
    sha256 "5deccbf55d750ce65588cd211c1a03fa1ef3aaa15d1ac2b8d85383a42c1427ea"
  end

  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.27.tar.gz"
    sha256 "11962d8a8a8496906e5d34774affc235a1c95c112d390c0b4171f3e91e9e2a97"
  end

  # XML::LibXML build dependencies
  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
    sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
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
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.144.tar.gz"
    sha256 "f6ea094ece845c952a02c2789332579354de8d410a707f9b7045bd241206487d"
  end
  resource "Alien::Build::Plugin::Download::GitLab" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-Plugin-Download-GitLab-0.01.tar.gz"
    sha256 "c1f089c8ea152a789909d48a83dbfcf2626f773daf30431c8622582b26aba902"
  end
  resource "Alien::Build" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.80.tar.gz"
    sha256 "d9edc936b06705bb5cb5ee5a2ea8bcf6111a3e8815914f177e15e3c0fed301f3"
  end
  resource "Alien::Libxml2" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.19.tar.gz"
    sha256 "f4a674099bbd5747c0c3b75ead841f3b244935d9ef42ba35368024bd611174c9"
  end

  # XML::LibXML dependencies
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

  resource "XML::LibXML" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0210.tar.gz"
    sha256 "a29bf3f00ab9c9ee04218154e0afc8f799bf23674eb99c1a9ed4de1f4059a48d"
  end

  resource "XML::LibXSLT" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXSLT-2.002001.tar.gz"
    sha256 "df8927c4ff1949f62580d1c1e6f00f0cd56b53d3a957ee4b171b59bffa63b2c0"
  end

  # LWP dependencies
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
  resource "File::Listing" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
    sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
  end
  resource "IO::HTML" do
    url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
    sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
  end
  resource "LWP::MediaTypes" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
    sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
  end
  resource "HTML::Tagset" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz"
    sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
  end
  resource "HTTP::Request" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.45.tar.gz"
    sha256 "01cb8406612a3f738842d1e97313ae4d874870d1b8d6d66331f16000943d4cbe"
  end
  resource "HTML::HeadParser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.81.tar.gz"
    sha256 "c0910a5c8f92f8817edd06ccfd224ba1c2ebe8c10f551f032587a1fc83d62ff2"
  end
  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.11.tar.gz"
    sha256 "8c9a541a4a39f6c0c7e3d0b700b05dfdb830bd490a1b1942a7dedd1b50d9a8c8"
  end
  resource "HTTP::Negotiate" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end
  resource "Net::HTTP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.23.tar.gz"
    sha256 "0d65c09dd6c8589b2ae1118174d3c1a61703b6ecfc14a3442a8c74af65e0c94e"
  end
  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
    sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
  end
  resource "WWW::RobotRules" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end

  resource "LWP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.76.tar.gz"
    sha256 "75c2e57d6102eea540f3611b56fd86268a59b022dd00ea6562ac36412fcdf8e1"
  end

  resource "Clone" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Clone-0.46.tar.gz"
    sha256 "aadeed5e4c8bd6bbdf68c0dd0066cb513e16ab9e5b4382dc4a0aafd55890697b"
  end

  def perl_build(install_base)
    system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}"
    system "make"
    system "make", "install"
  end

  def install
    install_perl5lib = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", install_perl5lib
    ENV.prepend_create_path "PERL5LIB", buildpath/"build/lib/perl5"
    ENV["PERL_CANARY_STABILITY_NOPROMPT"] = "1"

    # File::Which is a runtime dependency but also needed by Alien::Build, so install it first
    # URI needed by `Alien::Build::Plugin::PkgConfig::CommandLine`
    %w[File::Which URI].each do |r|
      resource(r).stage do
        perl_build(libexec)
      end
    end

    # Install build-only resources into temporary directory
    build_resources = %w[
      Canary::Stability
      Path::Tiny
      File::chdir
      FFI::CheckLib
      Capture::Tiny
      Alien::Build::Plugin::Download::GitLab
      Alien::Build
      Alien::Libxml2
    ]
    build_resources.each do |r|
      resource(r).stage do
        perl_build(buildpath/"build")
      end
    end

    # Install runtime resources into libexec
    runtime_resources = resources.to_set(&:name) - build_resources - ["File::Which", "URI"]
    runtime_resources.each do |r|
      resource(r).stage do
        perl_build(libexec)
      end
    end

    bin_before = Dir[libexec/"bin/*"].to_set
    perl_build(libexec)
    bin_after = Dir[libexec/"bin/*"].to_set
    (bin_after - bin_before).each do |path|
      next if File.directory?(path)

      program = File.basename(path)
      (bin/program).write_env_script libexec/"bin"/program, PERL5LIB: install_perl5lib
      man1.install_symlink libexec/"man/man1/#{program}.1"
    end
    doc.install "manual.pdf"
  end

  test do
    (testpath/"test.tex").write <<~'TEX'
      \documentclass{article}
      \title{LaTeXML Homebrew Test}
      \begin{document}
      \maketitle
      \end{document}
    TEX
    assert_match %r{<title>LaTeXML Homebrew Test</title>},
                 shell_output("#{bin}/latexml --quiet #{testpath}/test.tex")
  end
end
