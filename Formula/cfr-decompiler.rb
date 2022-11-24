class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://github.com/leibnitz27/cfr.git",
      tag:      "0.152",
      revision: "68477be3ff7171ee17ddd1a26064b9b253f1604f"
  license "MIT"
  head "https://github.com/leibnitz27/cfr.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?cfr[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7759d5fd2f4f74e7d467314638779081b4d5da9e17ec4fb571b6e762ba6e7e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0860e5883c6453777bcb7dfa447f99639c3bebfc281baa83ba31fca83f0d80a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87ac8a8345d70e1a9c7e6d8f5d0c6d2c53f41d54c4099895d3133dace7fd19fc"
    sha256 cellar: :any_skip_relocation, ventura:        "64800a8949222ab780a6d37a7d5407ff70b5818a5ea5804a05855d7585f7da2b"
    sha256 cellar: :any_skip_relocation, monterey:       "e8cbec43262bb913ebc307a19fddaf983ac149fdc32fd3cf09da6c1585afbf50"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb5d9c8ecdeef4e8e950d8b752f85dceb8cd4cf4b97b538f62d63be5c8ed7dff"
    sha256 cellar: :any_skip_relocation, catalina:       "31565bced5fabda93b658abf71ef43c2a5658c02ae226e385373001dba6503f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dc91498cbc8dbaacfed2b9c33aa0e8a290322ea108e4649c977cf8d7b17956e"
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
      /*
       * Decompiled with CFR #{version}.
       */
      class T {
          T() {
          }

          public static void main(String[] stringArray) {
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
