class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://github.com/leibnitz27/cfr.git",
      tag:      "0.151",
      revision: "fecd6421a8b9de98ade2b9f9b89caecf4a8c93d8"
  license "MIT"
  head "https://github.com/leibnitz27/cfr.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?cfr[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3f2087d72bd7319b4c34232db1c9e9e146c4919beb977b73af0676346612e73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75a69ae0a8ac09219854b6ed8b0ffff354c06cc01df7e3c343db71eb43489a02"
    sha256 cellar: :any_skip_relocation, monterey:       "1ac3936440308ed59bd95394516b8dfaf5e9184dd766f14e64a88e80f6759d71"
    sha256 cellar: :any_skip_relocation, big_sur:        "01b786e75cce66964d72c4da0e6545ed08275d7372e43f6e810c76bd65ee26d4"
    sha256 cellar: :any_skip_relocation, catalina:       "59ae9cd6d368e85589ffd31f2ae0c223b9635d6cd5787e9a360de5f743f15ba2"
    sha256 cellar: :any_skip_relocation, mojave:         "bad961cc5db80bdc29b4ac304147dc019b16efc01161a5e5289ad87cf835a5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca40a7dc226badddecc91362d34dcf1a4b77c94dc779ed8138daddeb2660cde6"
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
