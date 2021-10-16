class Latexml < Formula
  desc "LaTeX to XML/HTML/MathML Converter"
  homepage "https://dlmf.nist.gov/LaTeXML/"
  url "https://dlmf.nist.gov/LaTeXML/releases/LaTeXML-0.8.6.tar.gz"
  sha256 "803a6eaca7ea5811201cfedd5b1057543584c99984392d11d2eed132b74267f4"
  license :public_domain
  head "https://github.com/brucemiller/LaTeXML.git"

  livecheck do
    url "https://dlmf.nist.gov/LaTeXML/get.html"
    regex(/href=.*?LaTeXML[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1baf39e551bf724eec7bfa7f63e6f2f80307c3eb21f53ff05fad1bcd620a6ef9"
    sha256 cellar: :any_skip_relocation, big_sur:       "5311fc896eb2d27a5fa149bea4d30e6be0f6693cde9da9709b32f11212f726e1"
    sha256 cellar: :any_skip_relocation, catalina:      "3af6c43c91d733210e1e75db13093c72aa91addc1cc8ae94cd716de6ec73ea37"
    sha256 cellar: :any_skip_relocation, mojave:        "f51f58dc03c62130191b1bf2bb223459da93cdb7a7a1c3052a227a4bdc67dfe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8cfc70adb30f6d9427642a94fa48618b2242bcb2d11ec3c6256e6313fb12694"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "perl"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "Image::Size" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz"
    sha256 "53c9b1f86531cde060ee63709d1fda73cabc0cf2d581d29b22b014781b9f026b"
  end

  resource "Text::Unidecode" do
    url "https://cpan.metacpan.org/authors/id/S/SB/SBURKE/Text-Unidecode-1.30.tar.gz"
    sha256 "6c24f14ddc1d20e26161c207b73ca184eed2ef57f08b5fb2ee196e6e2e88b1c6"
  end

  resource "Path::Tiny" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.118.tar.gz"
      sha256 "32138d8d0f4c9c1a84d2a8f91bc5e913d37d8a7edefbb15a10961bfed560b0fd"
    end
  end

  resource "IO::String" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz"
      sha256 "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
    end
  end

  resource "File::Chdir" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1010.tar.gz"
      sha256 "efc121f40bd7a0f62f8ec9b8bc70f7f5409d81cd705e37008596c8efc4452b01"
    end
  end

  resource "Capture::Tiny" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
      sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
    end
  end

  resource "File::Which" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
      sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
    end
  end

  resource "Archive::Zip" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/Archive-Zip-1.68.tar.gz"
      sha256 "984e185d785baf6129c6e75f8eb44411745ac00bf6122fb1c8e822a3861ec650"
    end
  end

  resource "Alien::Build" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.42.tar.gz"
      sha256 "517c99c69fd236e106c1827896bd8562d7768043cc11bfbc399d55e95a63b791"
    end
  end

  resource "Alien::LibXML2" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.17.tar.gz"
      sha256 "73b45244f0b5c36e5332c33569b82a1ab2c33e263f1d00785d2003bcaec68db3"
    end
  end

  resource "LWP" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.57.tar.gz"
      sha256 "30c242359cb808f3fe2b115fb90712410557f0786ad74844f9801fd719bc42f8"
    end
  end

  resource "Parse::RecDescent" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz"
      sha256 "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37"
    end
  end

  resource "XML::LibXML" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0207.tar.gz"
      sha256 "903436c9859875bef5593243aae85ced329ad0fb4b57bbf45975e32547c50c15"
    end
  end

  resource "XML::Sax" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
      sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
    end
  end

  resource "XML::LibXSLT" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXSLT-1.99.tar.gz"
    sha256 "127e17a877fb61e47b9e8b87bf8daad31339a62a00121f9751d522b438b0f7f0"
  end

  resource "URI" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.09.tar.gz"
      sha256 "03e63ada499d2645c435a57551f041f3943970492baa3b3338246dab6f1fae0a"
    end
  end

  resource "HTTP::Request" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.33.tar.gz"
      sha256 "23b967f71b852cb209ec92a1af6bac89a141dff1650d69824d29a345c1eceef7"
    end
  end

  resource "Canary::Stability" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/Canary-Stability-2013.tar.gz"
      sha256 "a5c91c62cf95fcb868f60eab5c832908f6905221013fea2bce3ff57046d7b6ea"
    end
  end

  resource "JSON::XS" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/JSON-XS-4.03.tar.gz"
      sha256 "515536f45f2fa1a7e88c8824533758d0121d267ab9cb453a1b5887c8a56b9068"
    end
  end

  resource "Pod::Find" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.63.tar.gz"
      sha256 "dbe0b56129975b2f83a02841e8e0ed47be80f060686c66ea37e529d97aa70ccd"
    end
  end

  resource "HTTP::Date" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
      sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
    end
  end

  resource "Try::Tiny" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz"
      sha256 "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b"
    end
  end

  resource "Encode::Locale" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      next if r.name == "XML::LibXSLT" && OS.mac? && MacOS.version < :big_sur

      r.stage do
        ENV["PERL_CANARY_STABILITY_NOPROMPT"] = "1" if OS.linux?

        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "DEBUG=1", "verbose=1", "verb=1",
                                      "INST_ARCHLIB=#{Pathname.pwd}/blib/arch"
        system "make"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"
    doc.install "manual.pdf"
    (libexec/"bin").find.each do |path|
      next if path.directory?

      program = path.basename
      (bin/program).write_env_script(libexec/"bin"/program, PERL5LIB: ENV["PERL5LIB"])
    end
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
