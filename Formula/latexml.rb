class Latexml < Formula
  desc "LaTeX to XML/HTML/MathML Converter"
  homepage "http://dlmf.nist.gov/LaTeXML"
  url "http://dlmf.nist.gov/LaTeXML/releases/LaTeXML-0.8.2.tar.gz"
  sha256 "3d41a3012760d31d721b569d8c1b430cde1df2b68fcc3c66f41ec640965caabf"
  head "https://github.com/brucemiller/LaTeXML.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ae3ca257610559471ea0e1bbc9d5ff8f122790564a8e7027841e5b2356b6f8f" => :el_capitan
    sha256 "5205887f374d4bd15905f5f13b4c661c5a6cb2725fc631836cff0668e34085b5" => :yosemite
    sha256 "884426eb041a9fa05ba6ebc64c64f4ce76f7c10cab3c5c1b98bcce201831c9d2" => :mavericks
  end

  resource "Image::Size" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz"
    sha256 "53c9b1f86531cde060ee63709d1fda73cabc0cf2d581d29b22b014781b9f026b"
  end

  resource "Text::Unidecode" do
    url "http://search.cpan.org/CPAN/authors/id/S/SB/SBURKE/Text-Unidecode-1.27.tar.gz"
    sha256 "11876a90f0ce858d31203e80d62900383bb642ed8a470c67539b607f2a772d02"
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
    (testpath/"test.tex").write <<-EOS.undent
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
