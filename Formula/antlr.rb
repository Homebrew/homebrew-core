class Antlr < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr-4.12.0-complete.jar"
  sha256 "88f18a2bfac0dde1009eda5c7dce358a52877faef7868f56223a5bcc15329e43"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr[._-]v?(\d+(?:\.\d+)+)-complete\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd6e0a5741418c4d07644dbe6697a79f5d98a07d1396d009caad04dcb1ea5e3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd6e0a5741418c4d07644dbe6697a79f5d98a07d1396d009caad04dcb1ea5e3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd6e0a5741418c4d07644dbe6697a79f5d98a07d1396d009caad04dcb1ea5e3f"
    sha256 cellar: :any_skip_relocation, ventura:        "dd6e0a5741418c4d07644dbe6697a79f5d98a07d1396d009caad04dcb1ea5e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "dd6e0a5741418c4d07644dbe6697a79f5d98a07d1396d009caad04dcb1ea5e3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd6e0a5741418c4d07644dbe6697a79f5d98a07d1396d009caad04dcb1ea5e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80bb154cc36537be68ae865ff52bdf9988a2a2a1c66a63adb96eff8a560c946f"
  end

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
