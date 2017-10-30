class AntlrAT2 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "http://www.antlr2.org"
  url "http://www.antlr2.org/download/antlr-2.7.7.tar.gz"
  sha256 "853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9"

  bottle do
    cellar :any_skip_relocation
    sha256 "98b9371fac8dee3fdd61d7691549d8689e2c2ef7f911977fe1ec32227d2d8300" => :high_sierra
    sha256 "ec2e5dacbcbc0463cec0876b164de6f40b75443f51070b5c31755acf2ad6ffd4" => :sierra
    sha256 "3c340537a171cdf7c87788cd6e507a403decaf864dc81249a2da01e4bac5b3f7" => :el_capitan
    sha256 "90b75cee100dd1f98e50d3c858b5a54c5c676dca7fd22c81863be76504777180" => :yosemite
  end

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

    (bin/"antlr2").write <<~EOS
      #!/bin/sh
      java -classpath #{libexec}/antlr.jar antlr.Tool "$@"
    EOS
  end

  test do
    assert_match "ANTLR Parser Generator   Version #{version}",
      shell_output("#{bin}/antlr2 --help 2>&1")
  end
end
