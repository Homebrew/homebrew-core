class AntlrAT3 < Formula
  desc "Antlr3 has a C API which has been dropped in Antlr4."
  homepage "http://www.antlr.org/"
  url "http://www.antlr3.org/download/antlr-3.5.2-complete.jar"
  sha256 "26ca659f47d77384f518cf2b6463892fcd4f0b0d4d8c0de2addf697e63e7326b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed849f2435e121d0a0dbbbed4a027dd4f6f71db9a17a2f639bb1e492bdb1b7f0" => :high_sierra
    sha256 "450bb2d748965c0f25a280a2eb4fd9b371e6f403107053b610dedb030229009e" => :sierra
    sha256 "450bb2d748965c0f25a280a2eb4fd9b371e6f403107053b610dedb030229009e" => :el_capitan
    sha256 "450bb2d748965c0f25a280a2eb4fd9b371e6f403107053b610dedb030229009e" => :yosemite
  end

  depends_on :java

  def install
    libexec.install "antlr-3.5.2-complete.jar"
    (share+"java").install_symlink "#{libexec}/antlr-3.5.2-complete.jar" => "antlr3.jar"
    (bin+"antlr3").write <<~EOS
    #!/bin/sh
    java -jar #{libexec}/antlr-3.5.2-complete.jar "$@"
    EOS
  end

  test do
    exppath = testpath/"Exp.g"
    exppath.write <<~EOS
    grammar Exp;
    eval returns [double value]
        :    exp=atomExp {$value = $exp.value;}
        ;
    atomExp returns [double value]
        :    n=Number                {$value = Double.parseDouble($n.text);}
        ;
    Number
        :    ('0'..'9')+ ('.' ('0'..'9')+)?
        ;
    WS
        :   (' ' | '\\t' | '\\r'| '\\n') {\$channel=HIDDEN;}
        ;
    EOS
    javapath = testpath/"ANTLRDemo.java"
    javapath.write <<~EOS
    import org.antlr.runtime.*;
    public class ANTLRDemo {
        public static void main(String[] args) throws Exception {
            ANTLRStringStream in = new ANTLRStringStream("42");
            ExpLexer lexer = new ExpLexer(in);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            ExpParser parser = new ExpParser(tokens);
            System.out.println(parser.eval()); // print the value
        }
    }
    EOS
    ENV.prepend "CLASSPATH", "#{share}/java/antlr3.jar", ":"
    ENV.prepend "CLASSPATH", ".", ":"
    system "#{bin}/antlr3", "Exp.g"
    system "javac", "ANTLRDemo.java"
    assert_match("42.0", pipe_output("java ANTLRDemo"))
  end
end
