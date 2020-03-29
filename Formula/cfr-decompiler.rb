class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://github.com/leibnitz27/cfr/archive/0.149.tar.gz"
  sha256 "6d1883710ed1585cc4b675bc0d56b87351aff14dfc74270790b7bb3ff8f79743"
  head "https://github.com/leibnitz27/cfr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35b88d41ddbd0229f956d06a3b98e05dd6ab679bf54de808a9df272a8c2d133b" => :catalina
    sha256 "f8fb1fa876f5fe62e99cd86d9adbfd618640ff6e1a7018bce7098669f6869802" => :mojave
    sha256 "74d5486e47c43e6e58c007f6f2f7144b50ece8da29dd259645e9bc021fb433cb" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    # Homebrew's OpenJDK no longer accepts Java 6 source, so:
    inreplace "pom.xml", "<javaVersion>1.6</javaVersion>", "<javaVersion>1.7</javaVersion>"
    inreplace "cfr.iml", 'LANGUAGE_LEVEL="JDK_1_6"', 'LANGUAGE_LEVEL="JDK_1_7"'

    # build
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system Formula["maven"].bin/"mvn", "package"

    cd "target" do
      # switch on jar names
      if build.head?
        lib_jar = Dir["cfr-*-SNAPSHOT.jar"]
        doc_jar = Dir["cfr-*-SNAPSHOT-javadoc.jar"]
        odie "Unexpected number of artifacts!" unless (lib_jar.length == 1) && (doc_jar.length == 1)
        lib_jar = lib_jar[0]
        doc_jar = doc_jar[0]
      else
        lib_jar = "cfr-#{version}.jar"
        doc_jar = "cfr-#{version}-javadoc.jar"
      end

      # install library and binary
      libexec.install lib_jar
      (bin/"cfr-decompiler").write <<~EOS
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        exec "${JAVA_HOME}/bin/java" -jar "#{libexec/lib_jar}" "$@"
      EOS

      # install library docs
      doc.install doc_jar
      mkdir doc/"javadoc"
      cd doc/"javadoc" do
        system Formula["openjdk"].bin/"jar", "-xf", doc/doc_jar
        rm_rf "META-INF"
      end
    end
  end

  test do
    fixture = <<~EOS
      class T {
          T() {
          }

          public static void main(String[] arrstring) {
              System.out.println("Hello brew!");
          }
      }
    EOS
    (testpath/"T.java").write fixture
    system Formula["openjdk"].bin/"javac", "T.java"
    output = pipe_output("#{bin}/cfr-decompiler --comments false T.class")
    assert_match fixture, output
  end
end
