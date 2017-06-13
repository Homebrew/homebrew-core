class Antlr < Formula
  desc "ANother Tool for Language Recognition"
  homepage "http://www.antlr.org/"
  url "http://www.antlr.org/download/antlr-4.7-complete.jar"
  sha256 "cd8bc38c2b72426f8d5922843c1b8ffcd0238fa34722597a944a153d8c570864"

  bottle :unneeded

  depends_on :java

  def install
    prefix.install "antlr-#{version}-complete.jar"

    (bin/"antlr4").write <<-EOS.undent
      #!/bin/bash
      CLASSPATH="#{prefix}/antlr-#{version}-complete.jar:." exec java -jar #{prefix}/antlr-#{version}-complete.jar "$@"
    EOS

    (bin/"grun").write <<-EOS.undent
      #!/bin/bash
      java -classpath #{prefix}/antlr-#{version}-complete.jar:. org.antlr.v4.gui.TestRig "$@"
    EOS
  end

  test do
    path = testpath/"Expr.g4"
    path.write <<-EOS.undent
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
    system "#{bin}/antlr4", "Expr.g4"
    system "javac", *Dir["Expr*.java"]
    assert_match(/^$/, pipe_output("#{bin}/grun Expr prog", "22+20\n"))
  end
end
