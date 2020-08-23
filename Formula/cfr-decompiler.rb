class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://github.com/leibnitz27/cfr.git",
      tag:      "0.150",
      revision: "1361cd7fa74f25f30a6bbf72c825d83647d2cdaf"
  license "MIT"
  head "https://github.com/leibnitz27/cfr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05d1bff6093077a4f9789606c7b8d77d26f66f341aa491a9412da3e85669c932" => :catalina
    sha256 "0235b4a3204736079b3790db8de5bb02f99162318bff390aea45168f2bd1ea48" => :mojave
    sha256 "c6866f8e6b6c8e849936d2b5a45c3827dda9acacfe49ca2e831041e633617ac5" => :high_sierra
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
