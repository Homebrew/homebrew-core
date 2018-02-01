class Latexml < Formula
  desc "LaTeX to XML/HTML/MathML Converter"
  homepage "https://dlmf.nist.gov/LaTeXML/index.html"
  url "https://dlmf.nist.gov/LaTeXML/releases/LaTeXML-0.8.2.tar.gz"
  sha256 "3d41a3012760d31d721b569d8c1b430cde1df2b68fcc3c66f41ec640965caabf"
  head "https://github.com/brucemiller/LaTeXML.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbbeb393b7ed0258fdbf875e103a6f2f82103a6c19fce6b77ce5dd99fde9dc72" => :high_sierra
    sha256 "3d995988dc683269f6949f8071148ceaf7454e8e7eb37cd8d391a1eb4467fc76" => :sierra
    sha256 "5ae3ca257610559471ea0e1bbc9d5ff8f122790564a8e7027841e5b2356b6f8f" => :el_capitan
    sha256 "5205887f374d4bd15905f5f13b4c661c5a6cb2725fc631836cff0668e34085b5" => :yosemite
    sha256 "884426eb041a9fa05ba6ebc64c64f4ce76f7c10cab3c5c1b98bcce201831c9d2" => :mavericks
  end

  requires_perl = []
  requires_perl << "with-perl"
  depends_on "perl"                             # Actually, Imagemagick already installs Perl
  depends_on "imagemagick" => requires_perl     # Install ImageMagick with PerlMagick
  depends_on "ghostscript"

  #===# Perl Modules Dependencies (non-core as of 5.26.1) #===#
  # Archive::Zip => Test::MockModule
  # Test::MockModule => Module::Build, SUPER
  # Module::Build
  resource "Module::Build" do
    url "https://www.cpan.org/authors/id/L/LE/LEONT/Module-Build-0.4224.tar.gz"
    sha256 "a6ca15d78244a7b50fdbf27f85c85f4035aa799ce7dd018a0d98b358ef7bc782"
  end
  # SUPER => Sub::Identify
  # Sub::Identify
  resource "Sub::Identify" do
    url "https://www.cpan.org/authors/id/R/RG/RGARCIA/Sub-Identify-0.14.tar.gz"
    sha256 "068d272086514dd1e842b6a40b1bedbafee63900e5b08890ef6700039defad6f"
  end
  resource "SUPER" do
    url "https://www.cpan.org/authors/id/C/CH/CHROMATIC/SUPER-1.20141117.tar.gz"
    sha256 "1a620e7d60aee9b13b1b26a44694c43fdb2bba1755cfff435dae83c7d42cc0b2"
  end
  resource "Test::MockModule" do
    url "https://www.cpan.org/authors/id/G/GF/GFRANKS/Test-MockModule-0.13.tar.gz"
    sha256 "7473742a0d600eb11766752c79a966570755168105ee4d4e33d90466b7339053"
  end
  resource "Archive::Zip" do
    url "https://www.cpan.org/CPAN/authors/id/P/PH/PHRED/Archive-Zip-1.60.tar.gz"
    sha256 "eac75b05f308e860aa860c3094aa4e7915d3d31080e953e49bc9c38130f5c20b"
  end

  # DB_File
  resource "DB_File" do
    url "https://www.cpan.org/authors/id/P/PM/PMQS/DB_File-1.840.tar.gz"
    sha256 "b7864707fad0f2d1488c748c4fa08f1fb8bcfd3da247c36909fd42f20bfab2c4"
  end

  # File::Which
  resource "File::Which" do
    url "https://www.cpan.org/authors/id/P/PL/PLICEASE/File-Which-1.22.tar.gz"
    sha256 "e8a8ffcf96868c6879e82645db4ff9ef00c2d8a286fed21971e7280f52cf0dd4"
  end

  # Getopt::Long
  resource "Getopt::Long" do
    url "https://www.cpan.org/authors/id/J/JV/JV/Getopt-Long-2.50.tar.gz"
    sha256 "20881adb2b73e83825f9a0a3b141db11b3a555e1d3775b13d81d0481623e4b67"
  end

  # Image::Size => Module::Build
  # Module::Build
  resource "Module::Build" do
    url "https://www.cpan.org/authors/id/L/LE/LEONT/Module-Build-0.4224.tar.gz"
    sha256 "a6ca15d78244a7b50fdbf27f85c85f4035aa799ce7dd018a0d98b358ef7bc782"
  end
  resource "Image::Size" do
    url "https://www.cpan.org/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz"
    sha256 "53c9b1f86531cde060ee63709d1fda73cabc0cf2d581d29b22b014781b9f026b"
  end

  # IO::String
  resource "IO::String" do
    url "https://www.cpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz"
    sha256 "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
  end

  # JSON::XS => Types::Serialiser, Canary::Stability
  # Types::Serialiser => common::sense
  # common::sense
  resource "common::sense" do
    url "https://www.cpan.org/authors/id/M/ML/MLEHMANN/common-sense-3.74.tar.gz"
    sha256 "771f7d02abd1ded94d9e37d3f66e795c8d2026d04defbeb5b679ca058116bbf3"
  end
  resource "Types::Serialiser" do
    url "https://www.cpan.org/authors/id/M/ML/MLEHMANN/Types-Serialiser-1.0.tar.gz"
    sha256 "7ad3347849d8a3da6470135018d6af5fd8e58b4057cd568c3813695f2a04730d"
  end
  # Canary::Stability
  resource "Canary::Stability" do
    url "https://www.cpan.org/authors/id/M/ML/MLEHMANN/Canary-Stability-2012.tar.gz"
    sha256 "fd240b111d834dbae9630c59b42fae2145ca35addc1965ea311edf0d07817107"
  end
  resource "JSON::XS" do
    url "https://www.cpan.org/authors/id/M/ML/MLEHMANN/JSON-XS-3.04.tar.gz"
    sha256 "65d8836bd8ea6f0b7bffc70b2212156adc3e2ffa587e27e548d576893f097c2c"
  end

  # URI => Test::Needs
  # Test::Needs
  resource "Test::Needs" do
    url "https://www.cpan.org/authors/id/H/HA/HAARG/Test-Needs-0.002005.tar.gz"
    sha256 "5a4f33983586edacdbe00a3b429a9834190140190dab28d0f873c394eb7df399"
  end
  resource "URI" do
    url "https://www.cpan.org/authors/id/E/ET/ETHER/URI-1.73.tar.gz"
    sha256 "cca7ab4a6f63f3ccaacae0f2e1337e8edf84137e73f18548ec7d659f23efe413"
  end

  # LWP => Test::RequiresInternet, HTTP::Message, File::Listing, HTTP::Daemon, HTML::HeadParser, HTTP::Cookies, WWW::RobotRules, Test::Fatal, HTTP::Negotiate, Net::HTTP
  # Test::RequiresInternet
  resource "Test::RequiresInternet" do
    url "https://www.cpan.org/authors/id/M/MA/MALLEN/Test-RequiresInternet-0.05.tar.gz"
    sha256 "bba7b32a1cc0d58ce2ec20b200a7347c69631641e8cae8ff4567ad24ef1e833e"
  end
  # HTTP::Message => LWP::MediaTypes, Encode::Locale, IO::HTML, Try::Tiny, URI (already installed), HTTP::Date
  # LWP::MediaTypes
  resource "LWP::MediaTypes" do
    url "https://www.cpan.org/CPAN/authors/id/G/GA/GAAS/LWP-MediaTypes-6.02.tar.gz"
    sha256 "18790b0cc5f0a51468495c3847b16738f785a2d460403595001e0b932e5db676"
  end
  # Encode::Locale
  resource "Encode::Locale" do
    url "https://www.cpan.org/CPAN/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
    sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
  end
  # IO::HTML
  resource "IO::HTML" do
    url "https://www.cpan.org/CPAN/authors/id/C/CJ/CJM/IO-HTML-1.001.tar.gz"
    sha256 "ea78d2d743794adc028bc9589538eb867174b4e165d7d8b5f63486e6b828e7e0"
  end
  # Try::Tiny
  resource "Try::Tiny" do
    url "https://www.cpan.org/CPAN/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz"
    sha256 "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b"
  end
  # HTTP::Date
  resource "HTTP::Date" do
    url "https://www.cpan.org/CPAN/authors/id/G/GA/GAAS/HTTP-Date-6.02.tar.gz"
    sha256 "e8b9941da0f9f0c9c01068401a5e81341f0e3707d1c754f8e11f42a7e629e333"
  end
  resource "HTTP::Message" do
    url "https://www.cpan.org/CPAN/authors/id/O/OA/OALDERS/HTTP-Message-6.14.tar.gz"
    sha256 "71aab9f10eb4b8ec6e8e3a85fc5acb46ba04db1c93eb99613b184078c5cf2ac9"
  end
  # File::Listing
  resource "File::Listing" do
    url "https://www.cpan.org/authors/id/G/GA/GAAS/File-Listing-6.04.tar.gz"
    sha256 "1e0050fcd6789a2179ec0db282bf1e90fb92be35d1171588bd9c47d52d959cf5"
  end
  # HTTP::Daemon
  resource "HTTP::Daemon" do
    url "https://www.cpan.org/authors/id/G/GA/GAAS/HTTP-Daemon-6.01.tar.gz"
    sha256 "43fd867742701a3f9fcc7bd59838ab72c6490c0ebaf66901068ec6997514adc2"
  end
  # HTML::HeadParser => HTML::Tagset
  # HTML::Tagset
  resource "HTML::Tagset" do
    url "https://www.cpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz"
    sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
  end
  resource "HTML::HeadParser" do
    url "https://www.cpan.org/authors/id/G/GA/GAAS/HTML-Parser-3.72.tar.gz"
    sha256 "ec28c7e1d9e67c45eca197077f7cdc41ead1bb4c538c7f02a3296a4bb92f608b"
  end
  # HTTP::Cookies
  resource "HTTP::Cookies" do
    url "https://www.cpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.04.tar.gz"
    sha256 "0cc7f079079dcad8293fea36875ef58dd1bfd75ce1a6c244cd73ed9523eb13d4"
  end
  # WWW::RobotRules
  resource "WWW::RobotRules" do
    url "https://www.cpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end
  # Test::Fatal
  resource "Test::Fatal" do
    url "https://www.cpan.org/authors/id/R/RJ/RJBS/Test-Fatal-0.014.tar.gz"
    sha256 "bcdcef5c7b2790a187ebca810b0a08221a63256062cfab3c3b98685d91d1cbb0"
  end
  # HTTP::Negotiate
  resource "HTTP::Negotiate" do
    url "https://www.cpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end
  # Net::HTTP
  resource "Net::HTTP" do
    url "https://www.cpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.17.tar.gz"
    sha256 "1e8624b1618dc6f7f605f5545643ebb9b833930f4d7485d4124aa2f2f26d1611"
  end
  resource "LWP" do
    url "https://www.cpan.org/authors/id/E/ET/ETHER/libwww-perl-6.31.tar.gz"
    sha256 "525d5386d39d1c1d7da8a0e9dd0cbab95cba2a4bfcfd9b83b257f49be4eecae3"
  end

  # MIME::Base64
  resource "MIME::Base64" do
    url "https://www.cpan.org/authors/id/G/GA/GAAS/MIME-Base64-3.15.tar.gz"
    sha256 "7f863566a6a9cb93eda93beadb77d9aa04b9304d769cea3bb921b9a91b3a1eb9"
  end

  # Parse::RecDescent
  resource "Parse::RecDescent" do
    url "https://www.cpan.org/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz"
    sha256 "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37"
  end

  ## Pod::Parser # DO NOT INSTALL: conflicts with podselect from perl
  # resource "Pd::Paser" do
  # url "https://www.cpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.63.tar.gz"
  # sha256 "dbe0b56129975b2f83a02841e8e0ed47be80f060686c66ea37e529d97aa70ccd"
  # end

  # Text::Unidecode
  resource "Text::Unidecode" do
    url "https://www.cpan.org/authors/id/S/SB/SBURKE/Text-Unidecode-1.30.tar.gz"
    sha256 "6c24f14ddc1d20e26161c207b73ca184eed2ef57f08b5fb2ee196e6e2e88b1c6"
  end

  # Test::More
  resource "Test::More" do
    url "https://www.cpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302120.tar.gz"
    sha256 "c82360092d4dacd6e3248b613fa00053072fe9cf55d022f1e0f427f51d04346c"
  end

  # XML::LibXML => XML::SAX
  # XML::SAX => XML::NamespaceSupport, XML::SAX::Base
  # XML::NamespaceSupport
  resource "XML::NamespaceSupport" do
    url "https://www.cpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz"
    sha256 "47e995859f8dd0413aa3f22d350c4a62da652e854267aa0586ae544ae2bae5ef"
  end
  # XML::SAX::Base
  resource "XML::SAX::Base" do
    url "https://www.cpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
    sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
  end
  resource "XML::SAX" do # For XML::SAX, use make pure_site_install
    url "https://www.cpan.org/authors/id/G/GR/GRANTM/XML-SAX-0.99.tar.gz"
    sha256 "32b04b8e36b6cc4cfc486de2d859d87af5386dd930f2383c49347050d6f5ad84"
  end
  resource "XML::LibXML" do
    url "https://www.cpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0132.tar.gz"
    sha256 "721452e3103ca188f5968ab06d5ba29fe8e00e49f4767790882095050312d476"
  end

  # XML::LibXSLT => XML::LibXML (already installed)
  resource "XML::LibXSLT" do
    url "https://www.cpan.org/authors/id/S/SH/SHLOMIF/XML-LibXSLT-1.95.tar.gz"
    sha256 "f1ca21135acc53af9f175958ef5fceb453fd0ef383cfb0e6ef6ea24031f3ef35"
  end

  # UUID::Tiny
  resource "UUID::Tiny" do
    url "https://www.cpan.org/authors/id/C/CA/CAUGUSTIN/UUID-Tiny-1.04.tar.gz"
    sha256 "6dcd92604d64e96cc6c188194ae16a9d3a46556224f77b6f3d1d1312b68f9a3d"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    # Install the necessary Perl modules
    ENV["PERL_CANARY_STABILITY_NOPROMPT"]="1"
    ENV["PERL_MM_USE_DEFAULT"]="1"
    resources.each do |r|
      r.stage do
        if r.name == "Test::MockModule"
          system "perl", "Build.PL", "--install_base=#{libexec}"
          system "./Build"
          system "./Build", "test"
          system "./Build", "install"
        else
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make"
        end
        if r.name == "XML::SAX"
          system "make", "pure_site_install"
        elsif r.name != "Test::MockModule"
          system "make", "install"
        end
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"
    doc.install "manual.pdf"
    (libexec+"bin").find.each do |path|
      next if path.directory?
      program = path.basename
      (bin+program).write_env_script("#{libexec}/bin/#{program}", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  def caveats
    <<~EOS
      LaTeXML can work without LaTeX; however, a LaTeX installation is highly recommended.
      You can install LaTeX here: https://www.tug.org/mactex/.
    EOS
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\title{LaTeXML Homebrew Test}
      \\begin{document}
      \\maketitle
      \\end{document}
    EOS
    assert_match %r{<title>LaTeXML Homebrew Test</title>},
    shell_output("#{bin}/latexml --quiet #{testpath}/test.tex")
  end
end
