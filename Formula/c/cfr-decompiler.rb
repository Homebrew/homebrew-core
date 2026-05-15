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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab8834addd1841f1c2956e76a9ad07ba5de8baca81dcb20834ab0509c3c06c13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40e70dbc8a02f9af88b53433bb613530987d9cb816ac2225f2d723c40aa28571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ea66fb664c3dfa1afd2f261fe9899ad1a3edfd8ceb83fb43e1d35136bdb41ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2b939bf2b019303372c0a586249644cbfae34da0fc124f61c0d41039b834279"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acb9fe0f76e43403de2c4f013238038b1359c1aed573cb0081d0414342b2e410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b080b0a210c10148733e753b1b4ff7fcb4a05c67a086b8c698b99250a94e3e1f"
  end

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix
    # changing the compiler because 6 is used by upstream and openjdk no longer supports it
    system Formula["maven"].bin/"mvn", "package", "-Dmaven.compiler.source=8", "-Dmaven.compiler.target=8"

    cd "target" do
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
      bin.write_jar_script libexec/lib_jar, "cfr-decompiler", java_version: "21"

      # install library docs
      doc.install doc_jar
      mkdir doc/"javadoc"
      cd doc/"javadoc" do
        system Formula["openjdk@21"].bin/"jar", "-xf", doc/doc_jar
        rm_r("META-INF")
      end
    end
  end

  test do
    fixture = <<~JAVA
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
    JAVA
    (testpath/"T.java").write fixture
    system Formula["openjdk@21"].bin/"javac", "T.java"
    output = pipe_output("#{bin}/cfr-decompiler --comments false T.class")
    assert_match fixture, output
  end
end
