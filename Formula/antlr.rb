class Antlr < Formula
  desc "ANTLR: ANother Tool for Language Recognition"
  homepage "http://www.antlr.org/"
  url "http://www.antlr.org/download/antlr-4.5.3-complete.jar"
  sha256 "a32de739cfdf515774e696f91aa9697d2e7731e5cb5045ca8a4b657f8b1b4fb4"

  bottle :unneeded

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
