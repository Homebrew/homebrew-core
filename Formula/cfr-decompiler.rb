class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://github.com/leibnitz27/cfr.git",
      tag:      "0.150",
      revision: "1361cd7fa74f25f30a6bbf72c825d83647d2cdaf"
  license "MIT"
  head "https://github.com/leibnitz27/cfr.git"

  livecheck do
    url :homepage
    regex(/href=.*?cfr[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c57a78cf07cfa022d923fdd3ae4a3121009745e27aef50ff44a64a3144732552" => :big_sur
    sha256 "0fdf9bba0c9eab8903844218862ae65cbbae69f97b35f36024877d3d087702a5" => :arm64_big_sur
    sha256 "15268d8c8cb85a283c6f122331cdfbbf380c097e8c0faeea53b92970569d95e1" => :catalina
    sha256 "735f265fa827e2989a77f35781ca0f5ebae56c076c39a0368d41025d3a28edb5" => :mojave
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
        odie "Unexpected number of artifacts!" if (lib_jar.length != 1) || (doc_jar.length != 1)
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
