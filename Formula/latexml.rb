class Latexml < Formula
  desc "LaTeX to XML/HTML/MathML Converter"
  homepage "https://dlmf.nist.gov/LaTeXML/"
  url "https://dlmf.nist.gov/LaTeXML/releases/LaTeXML-0.8.6.tar.gz"
  sha256 "9529c651b67f5e8ddef1fd1852f974e756a17b711c46d4118f0677ad0e6e9bb1"
  license :public_domain
  revision 1
  head "https://github.com/brucemiller/LaTeXML.git", branch: "master"

  livecheck do
    url "https://dlmf.nist.gov/LaTeXML/get.html"
    regex(/href=.*?LaTeXML[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "810c20fb7bac966b37759b87f82de80b07d750ca21185ffdd5844e88d01e6d39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fee8ad2f09b1f5473b7973311bf78aba0e72183b6dd4415bbae4b84b73727232"
    sha256 cellar: :any_skip_relocation, monterey:       "484927731c70a13a3d889289aaa7c240bfc686988a91892803b2779adafeca2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "89dd1f99cc1574b070149f320b3e6ed89320ae4e4f43cb5b930fd3abae954467"
    sha256 cellar: :any_skip_relocation, catalina:       "6c5fd9798b62ccbf4bb9a510e2468d605fe9e488cb1c2d19e304d24a738dc598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b705a600d727333824a287cee780e4f691c5d8f8c205fa5965b654e7479ae590"
  end

  depends_on "pkg-config" => :build
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
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.65.tar.gz"
    sha256 "3ba7bdec659416a51fe2a7e59f0883e9c6a3b21bc9d001042c1d6a32d401b28a"
  end

  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.10.tar.gz"
    sha256 "16325d5e308c7b7ab623d1bf944e1354c5f2245afcfadb8eed1e2cae9a0bd0b5"
  end

  # XML::LibXML build dependencies
  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
    sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
  end
  resource "FFI::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/FFI-CheckLib-0.28.tar.gz"
    sha256 "cf377ce735b332c41f600ca6c5e87af30db6c3787f9b67d50a245d1ebe6fc350"
  end
  resource "File::chdir" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1010.tar.gz"
    sha256 "efc121f40bd7a0f62f8ec9b8bc70f7f5409d81cd705e37008596c8efc4452b01"
  end
  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.122.tar.gz"
    sha256 "4bc6f76d0548ccd8b38cb66291a885bf0de453d0167562c7b82e8861afdcfb7c"
  end
  resource "Alien::Build" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.50.tar.gz"
    sha256 "4ed2e175ba2d46d77fc8bb3b726a583cd3b28dc5c2885c375cfa2bf2a7c17347"
  end
  resource "Alien::Libxml2" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.17.tar.gz"
    sha256 "73b45244f0b5c36e5332c33569b82a1ab2c33e263f1d00785d2003bcaec68db3"
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
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0207.tar.gz"
    sha256 "903436c9859875bef5593243aae85ced329ad0fb4b57bbf45975e32547c50c15"
  end

  resource "XML::LibXSLT" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXSLT-2.002000.tar.gz"
    sha256 "4fd131c5a15f2f79e706810a70f3a5d08a6d1c946dcb39523f2c2ac948118a17"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
    sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
  end
  resource "File::Listing" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.15.tar.gz"
    sha256 "46c4fb9f9eb9635805e26b7ea55b54455e47302758a10ed2a0b92f392713770c"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.37.tar.gz"
    sha256 "0e59da0a85e248831327ebfba66796314cb69f1bfeeff7a9da44ad766d07d802"
  end
  resource "HTML::HeadParser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.78.tar.gz"
    sha256 "22564002f206af94c1dd8535f02b0d9735125d9ebe89dd0ff9cd6c000e29c29d"
  end
  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.10.tar.gz"
    sha256 "e36f36633c5ce6b5e4b876ffcf74787cc5efe0736dd7f487bdd73c14f0bd7007"
  end
  resource "HTTP::Negotiate" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end
  resource "Net::HTTP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.22.tar.gz"
    sha256 "62faf9a5b84235443fe18f780e69cecf057dea3de271d7d8a0ba72724458a1a2"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.67.tar.gz"
    sha256 "96eec40a3fd0aa1bd834117be5eb21c438f73094d861a1a7e5774f0b1226b723"
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
    resource("File::Which").stage do
      perl_build(libexec)
    end

    # Install build-only resources into temporary directory
    build_resources = %w[
      Canary::Stability
      Path::Tiny
      File::chdir
      FFI::CheckLib
      Capture::Tiny
      Alien::Build
      Alien::Libxml2
    ]
    build_resources.each do |r|
      resource(r).stage do
        perl_build(buildpath/"build")
      end
    end

    # Install runtime resources into libexec
    runtime_resources = resources.map(&:name).to_set - build_resources - ["File::Which"]
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
