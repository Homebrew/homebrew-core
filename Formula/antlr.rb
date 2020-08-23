class Antlr < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr-4.8-complete.jar"
  sha256 "73a49d6810d903aa4827ee32126937b85d3bebec0a8e679b0dd963cbcc49ba5a"
  license "BSD-3-Clause"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    prefix.install "antlr-#{version}-complete.jar"

    (bin/"antlr").write <<~EOS
      #!/bin/bash
      CLASSPATH="#{prefix}/antlr-#{version}-complete.jar:." exec "#{Formula["openjdk"].opt_bin}/java" -jar #{prefix}/antlr-#{version}-complete.jar "$@"
    EOS

    (bin/"grun").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -classpath #{prefix}/antlr-#{version}-complete.jar:. org.antlr.v4.gui.TestRig "$@"
    EOS
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
    system "#{bin}/antlr", "Expr.g4"
    system "#{Formula["openjdk"].bin}/javac", *Dir["Expr*.java"]
    assert_match(/^$/, pipe_output("#{bin}/grun Expr prog", "22+20\n"))
  end
end
