class Latexml < Formula
  desc "LaTeX to XML/HTML/MathML Converter"
  homepage "https://dlmf.nist.gov/LaTeXML/"
  url "https://dlmf.nist.gov/LaTeXML/releases/LaTeXML-0.8.3.tar.gz"
  sha256 "28a57369b65b85d09c1a2516e69d26bbbe102ab790cae5e2fc9709b26185f62f"
  head "https://github.com/brucemiller/LaTeXML.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36de089404dd52d462028b937d3c05af353e3c418b19c45a463bc0395d04a5fa" => :mojave
    sha256 "bbbeb393b7ed0258fdbf875e103a6f2f82103a6c19fce6b77ce5dd99fde9dc72" => :high_sierra
    sha256 "3d995988dc683269f6949f8071148ceaf7454e8e7eb37cd8d391a1eb4467fc76" => :sierra
    sha256 "5ae3ca257610559471ea0e1bbc9d5ff8f122790564a8e7027841e5b2356b6f8f" => :el_capitan
    sha256 "5205887f374d4bd15905f5f13b4c661c5a6cb2725fc631836cff0668e34085b5" => :yosemite
    sha256 "884426eb041a9fa05ba6ebc64c64f4ce76f7c10cab3c5c1b98bcce201831c9d2" => :mavericks
  end

  resource "Image::Size" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz"
    sha256 "53c9b1f86531cde060ee63709d1fda73cabc0cf2d581d29b22b014781b9f026b"
  end

  resource "Text::Unidecode" do
    url "https://cpan.metacpan.org/authors/id/S/SB/SBURKE/Text-Unidecode-1.30.tar.gz"
    sha256 "6c24f14ddc1d20e26161c207b73ca184eed2ef57f08b5fb2ee196e6e2e88b1c6"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"
    resources.each do |r|
      r.stage do
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
      (bin+program).write_env_script("#{libexec}/bin/#{program}", :PERL5LIB => ENV["PERL5LIB"])
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
