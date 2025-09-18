class Kimwituxx < Formula
  desc "Tool for processing trees (i.e. terms)"
  homepage "https://savannah.nongnu.org/projects/kimwitu-pp"
  url "https://download.savannah.gnu.org/releases/kimwitu-pp/kimwitu++-2.3.13.tar.gz"
  sha256 "3f6d9fbb35cc4760849b18553d06bc790466ca8b07884ed1a1bdccc3a9792a73"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/kimwitu-pp/"
    regex(/href=.*?kimwitu\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4f61b0ab3ba1cb98d66955c552211df3a280a78c0d922641ef9388803b1d7c55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3861ff2b9ae3eacfcb277bc50b6a3b1e16c608c807ff082ea2b2fe6d739f6608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35b17dd52015ae03a53788fc887c4b4943ab78b18f16fa6194b697e16fc69c3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a97df5c3b9f227ae34a2e87b7a4a4ec12988efeceabd2137b0dfe619da8ded6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b54a601b646e3e2b70d0ef3042a6c2180c51dbb0371078134463de043be1d4d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2291141a641d3529702fae53de9669d0b557694157b5c196eda1c56484ec67a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab6ad6f27ecf0cffb9459cb6dcdc8cb5272deace442b41f261807ac7dc8e180a"
    sha256 cellar: :any_skip_relocation, ventura:        "d434374974309b23dcf7aabe1778ac02b2328173c8723db794f9b22b8309db8c"
    sha256 cellar: :any_skip_relocation, monterey:       "6f02b1694547ba1ade265cbfaf9cf8357c64260e551abb34d8f5b3341dd16eaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dcd1be78b92b98d73dad285fbaaf507bdc23805835a51f56236ddd8b0eb73f5"
    sha256 cellar: :any_skip_relocation, catalina:       "470e06521034cea8db6ad07e8aab45c5bfbe3969cd03891799348eb4e9279c90"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e0031ff223a86e82dfb9450e9d0b0f9a9f77a07f3ce4d4a1c7ed8d7103aff4fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cece1163e971acd007363d1bd70c61a0d85a056b85cd878d53b520c330479754"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kc++ --version")

    # from: https://www.nongnu.org/kimwitu-pp/example/main.k.html
    (testpath/"main.k").write <<~EOS
      // Reverse Polish Notation, main.k
      // © 2001, Michael Piefel <piefel@informatik.hu-berlin.de>

      %{
      #include <iostream>
      #include "k.h"
      #include "rk.h"
      #include "unpk.h"
      #include "csgiok.h"

      int yyparse();
      line TheLine;
      %}
      %{ KC_TYPES_HEADER
      extern line TheLine;
      %}

      // Yes, create YYSTYPE union for the bison parser.
      %option yystype

      // Trivial printer function (ignores view)
      void
      printer(const char *s, uview v)
      {
              std::cout << s;
      }

      int
      main(int argc, char **argv)
      {
              FILE* f;

              std::cout << " RPN Parser and reformatter " << std::endl;
              // If a saved tree is given on command line, read it
              if (argc==2) {
                  f=fopen(argv[1], "r");
                  kc::CSGIOread(f, TheLine);
                  fclose(f);
              } else yyparse();

              line TheCanonLine=TheLine->rewrite(canon);
              line TheShortLine=TheCanonLine->rewrite(calculate);

              std::cout << "\nInfix notation:\n";
              TheCanonLine->unparse(printer, infix);

              std::cout << "\n\nCanonical postfix notation:\n";
              TheCanonLine->unparse(printer, postfix);

              std::cout << "\n\nCalculated infix notation:\n";
              TheShortLine->unparse(printer, infix);

              std::cout << "\n\nCalculated canonical postfix notation:\n";
              TheShortLine->unparse(printer, postfix);

              std::cout << std::endl;
      }
    EOS
    system bin/"kc++", testpath/"main.k"
  end
end
