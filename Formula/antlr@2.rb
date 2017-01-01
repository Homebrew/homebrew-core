class AntlrAT2 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "http://www.antlr2.org"
  url "http://www.antlr2.org/download/antlr-2.7.7.tar.gz"
  sha256 "853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9"

  depends_on :java

  def install
    # C Sharp is explicitly disabled because the antlr configure script will
    # confuse the Chicken Scheme compiler, csc, for a C sharp compiler.
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-csharp"
    system "make"

    libexec.install "antlr.jar"
    include.install "lib/cpp/antlr"
    lib.install "lib/cpp/src/libantlr.a"

    (bin/"antlr2").write <<-EOS.undent
      #!/bin/sh
      java -classpath #{libexec}/antlr.jar antlr.Tool "$@"
    EOS
  end

  test do
    assert_match "ANTLR Parser Generator   Version #{version}",
      shell_output("#{bin}/antlr2 --help 2>&1")
  end
end
