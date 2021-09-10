class Latexml < Formula
  desc "LaTeX to XML/HTML/MathML Converter"
  homepage "https://dlmf.nist.gov/LaTeXML/"
  url "https://dlmf.nist.gov/LaTeXML/releases/LaTeXML-0.8.5.tar.gz"
  sha256 "1de821d0df8c88041ee10820188f33feac77d5618de4c0798a296a425f4e2637"
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
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.108.tar.gz"
      sha256 "3c49482be2b3eb7ddd7e73a5b90cff648393f5d5de334ff126ce7a3632723ff5"
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
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.23.tar.gz"
      sha256 "b79dc2244b2d97b6f27167fc3b7799ef61a179040f3abd76ce1e0a3b0bc4e078"
    end
  end

  resource "Archive::Zip" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/Archive-Zip-1.64.tar.gz"
      sha256 "de5f84f2148038363d557b1fa33f58edc208111f789f7299fe3d8f6e11b4d17d"
    end
  end

  resource "Alien::Build" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-1.78.tar.gz"
      sha256 "132c71bbf4248af401a4780308ac98d98471f6efae2f4f56aea5ef3677406fc9"
    end
  end

  resource "Alien::LibXML2" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.09.tar.gz"
      sha256 "926e43bfcdd70bc111795b78bc41dd3a5c80f466eec5841d32aa6a497228dcba"
    end
  end

  resource "LWP" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.39.tar.gz"
      sha256 "9a8d7747938aa75d7d524c71574ae7f99ca66a5dac8255a7f7759f373e7774d5"
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
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0201.tar.gz"
      sha256 "e008700732502b3f1f0890696ec6e2dc70abf526cd710efd9ab7675cae199bc2"
    end
  end

  resource "XML::Sax" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
      sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
    end
  end

  resource "XML::LibXSLT" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXSLT-1.96.tar.gz"
      sha256 "2a5e374edaa2e9f9d26b432265bfea9b4bb7a94c9fbfef9047b298fce844d473"
    end
  end

  resource "URI" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-1.76.tar.gz"
      sha256 "b2c98e1d50d6f572483ee538a6f4ccc8d9185f91f0073fd8af7390898254413e"
    end
  end

  resource "HTTP::Request" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.18.tar.gz"
      sha256 "d060d170d388b694c58c14f4d13ed908a2807f0e581146cef45726641d809112"
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
      url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/JSON-XS-4.02.tar.gz"
      sha256 "a5ad172138071a14729da8a01921ca233da4fe2bed290ffdfb8e560dd8adcf16"
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
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"
    resources.each do |r|
      r.stage do
        ENV["PERL_CANARY_STABILITY_NOPROMPT"] = "1" if OS.linux?

        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"
    doc.install "manual.pdf"
    (libexec+"bin").find.each do |path|
      next if path.directory?

      program = path.basename
      (bin+program).write_env_script("#{libexec}/bin/#{program}", PERL5LIB: ENV["PERL5LIB"])
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
