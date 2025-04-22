class Antlr < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr-4.13.2-complete.jar"
  sha256 "eae2dfa119a64327444672aff63e9ec35a20180dc5b8090b7a6ab85125df4d76"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr[._-]v?(\d+(?:\.\d+)+)-complete\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51675080a8ca4a12f374f985f7ca5867606ef491b680a84d0e83484849f907ef"
  end

  depends_on "openjdk"

  def install
    prefix.install "antlr-#{version}-complete.jar"

    (bin/"antlr").write <<~SHELL
      #!/bin/bash
      CLASSPATH="#{prefix}/antlr-#{version}-complete.jar:." exec "#{Formula["openjdk"].opt_bin}/java" -jar #{prefix}/antlr-#{version}-complete.jar "$@"
    SHELL

    (bin/"grun").write <<~SHELL
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -classpath #{prefix}/antlr-#{version}-complete.jar:. org.antlr.v4.gui.TestRig "$@"
    SHELL
  end

  test do
    path = testpath/"Expr.g4"
    path.write <<~EOS
      grammar Expr;
      prog:\t(expr NEWLINE)* ;
      expr:\texpr ('*'|'/') expr
          |\texpr ('+'|'-') expr
          |\tINT
          |\t'(' expr ')'
          ;
      NEWLINE :\t[\\r\\n]+ ;
      INT     :\t[0-9]+ ;
    EOS
    ENV.prepend "CLASSPATH", "#{prefix}/antlr-#{version}-complete.jar", ":"
    ENV.prepend "CLASSPATH", ".", ":"
    system bin/"antlr", "Expr.g4"
    system Formula["openjdk"].bin/"javac", *Dir["Expr*.java"]
    assert_match(/^$/, pipe_output("#{bin}/grun Expr prog", "22+20\n", 0))
  end
end
